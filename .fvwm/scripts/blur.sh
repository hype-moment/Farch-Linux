#!/usr/bin/env bash

if [[ "$1" != "--worker" ]]; then
  # Where to write stuff
  export CACHE_DIR="/tmp/feh-blur.$$"

  # How much to blur (--blur N)
  export BLUR_STRENGTH="4"

  # Contrast (--uncontrast)
  export REDUCE_CONTRAST="0"

  # How much to dim (--dim N)
  export DIM_STRENGTH="4"

  # Dimmer
  export DIM_COLOR="#000"

  # Where to write the final blurred image (--save-image PATH)
  export BLUR_IMAGE_SAVE_LOCATION=""

  # Interval between frames in an animation
  export ANIMATION_INTERVAL=0.22

  # Fade in and out?
  export ANIMATE_FADE=60

  # Interval to check with wmctrl
  export POLL_INTERVAL=0.12

  # The verbosity. --verbose sets this to 2, and --quiet sets it to 0.
  export VERBOSE=1
fi

# The name of this program
export BIN="$(basename "$0")"

# Expression for proc grepping
PROC_EXPR="bash.*$(basename "$0")"

# Run mode. -d sets this to background (daemon) mode.
# Values: background | foreground | noop
MODE=foreground

# Guard so that do_cleanup will only be invoked once.
CLEANING_UP=0

# Image extension to use. 'ppm' is used because it's faster to read/write to, I
# think.
EXT="ppm"

# The original source.
wall_original="$CACHE_DIR/original.$EXT"

# Echo some info. Only if verbose=1
info () {
  if [[ "$VERBOSE" -gt 0 ]]; then
    echo "    $1"
  fi
}

head () {
  if [[ "$VERBOSE" -gt 0 ]]; then
    echo ""
    echo -e " \033[31m>>\033[32m $1\033[0m"
  fi
}

# Log some debug info
debug () {
  if [[ "$VERBOSE" -gt 1 ]]; then
    echo "  - $1"
  fi
}

# Generate a bunch of images
generate_blurred_images () {
  mkdir -p "$CACHE_DIR"
  local source="$1"
  local original="$CACHE_DIR/original.$EXT"

  gm convert "$source" -resize 1920x "$original"

  head "Found wallpaper"
  info "$source"
  info "Generating blurred images..."

  local fx1=""
  local fx2=""
  local fx3=""

  if [[ "$BLUR_STRENGTH" != "0" ]]; then 
    fx1="$fx1 -scale 25% -blur 0x$(( "$BLUR_STRENGTH" / 4 )) -scale 400%"
    fx2="$fx2 -scale 25% -blur 0x$(( "$BLUR_STRENGTH" / 2 )) -scale 400%"
    fx3="$fx3 -scale 25% -blur 0x$(( "$BLUR_STRENGTH" / 1 )) -scale 400%"
  fi

  if [[ "$REDUCE_CONTRAST" = "1" ]]; then
    fx1="+contrast $fx1"
    fx2="+contrast +contrast $fx2"
    fx3="+contrast +contrast +contrast $fx3"
  fi

  if [[ "$DIM_STRENGTH" != "0" ]]; then
    fx1="$fx1 -fill $DIM_COLOR -colorize $(( "$DIM_STRENGTH" / 4 ))%"
    fx2="$fx2 -fill $DIM_COLOR -colorize $(( "$DIM_STRENGTH" / 2 ))%"
    fx3="$fx3 -fill $DIM_COLOR -colorize $(( "$DIM_STRENGTH" / 1 ))%"
  fi

  gm convert "$original" \
    $fx1 \
    "$CACHE_DIR/blur-0.$EXT"
  gm convert "$CACHE_DIR/blur-0.$EXT" \
    $fx2 \
    "$CACHE_DIR/blur-1.$EXT"
  gm convert "$CACHE_DIR/blur-0.$EXT" \
    $fx3 \
    "$CACHE_DIR/blur-final.$EXT"

  if [[ -n "$BLUR_IMAGE_SAVE_LOCATION" ]]; then
    gm convert \
      "$CACHE_DIR/blur-final.$EXT" \
      "$BLUR_IMAGE_SAVE_LOCATION"
  fi

  info "Done."
}

# Get current feh wallpaper
get_feh_wallpaper() {
  tail -n1 "$HOME/.fehbg" | sed 's/--no-fehbg //g' | cut -d"'" -f2
}

# Get wallpaper mode like --bg-tile
get_feh_wallpaper_mode() {
  tail -n1 "$HOME/.fehbg" | sed 's/--no-fehbg //g' | cut -d' ' -f2
}

# get_current_workspace => "2"
get_current_workspace() {
  # 2 * DG: N/A VP: 0,0 WA: N/A Name
  wmctrl -d | grep '\*' | cut -d' ' -f1
}

# get_open_windows_count() => "2"
get_open_windows_count() {
  workspace="$(get_current_workspace)"
  wmctrl -l | cut -d' ' -f3 | grep -c "$workspace"
}

is_blank() {
  count=$(get_open_windows_count)
  [[ "$count" -eq 0 ]]
}

set_blurred_wallpaper() {
  debug "Setting blurred wallpaper"
  local mode="$1" # --bg-tile

  if [[ "$ANIMATE_FADE" == 1 ]]; then
    # We're going to redirect output to /dev/null to supress feh warnings
    feh --no-fehbg "$mode" "$CACHE_DIR/blur-0.$EXT" &> /dev/null
    sleep $ANIMATION_INTERVAL
    feh --no-fehbg "$mode" "$CACHE_DIR/blur-1.$EXT" &> /dev/null
    sleep $ANIMATION_INTERVAL
  fi

  feh --no-fehbg "$mode" "$CACHE_DIR/blur-final.$EXT" &> /dev/null
}

set_original_wallpaper() {
  debug "Setting original wallpaper"
  local mode="$1" # --bg-tile

  if [[ "$ANIMATE_FADE" == 1 ]]; then
    feh --no-fehbg "$mode" "$CACHE_DIR/blur-1.$EXT" &> /dev/null
    sleep $ANIMATION_INTERVAL
    feh --no-fehbg "$mode" "$CACHE_DIR/blur-0.$EXT" &> /dev/null
    sleep $ANIMATION_INTERVAL
  fi

  feh --no-fehbg "$mode" "$wall_original" &> /dev/null
}

kill_other_instances() {
  if [[ "$(pgrep -fcl "$PROC_EXPR")" -gt 1 ]]; then
    head "Stopping other instances of $BIN..."

    local count=1
    while [[ "$(pgrep -fcl "$PROC_EXPR")" -gt 1 ]]; do
      count=$(( count + 1 ))
      old_pid="$(pgrep -fo "$PROC_EXPR")"

      # Kill it; if it refuses after some time, force-stop it
      if [[ "$count" -gt 10 ]]; then
        kill -9 "$old_pid"
      else
        kill "$old_pid"
      fi
      sleep 0.1
    done
  fi
}

run_loop () {
  prev_blank="-"
  prev_wallpaper="-"
  first_run="1"

  while true; do
    wallpaper="$(get_feh_wallpaper)"

    # Check if wallpaper has changed.
    if [[ "$prev_wallpaper" != "$wallpaper" ]]; then
      wallpaper_mode="$(get_feh_wallpaper_mode)"

      # If there's no wallpaper, try again later.
      if [[ -z "$wallpaper" ]]; then
        sleep "$POLL_INTERVAL"
        continue
      else
        generate_blurred_images "$wallpaper"
        prev_wallpaper="$wallpaper"
        prev_blank=""
      fi
    fi

    blank="$(is_blank && echo 1 || echo 0)"
    if [[ "$prev_blank" != "$blank" ]]; then
      if [[ "$blank" == 0 ]]; then
        set_blurred_wallpaper "$wallpaper_mode"
      elif [[ "$first_run" == "0" ]]; then
        # Skip set_original_wallpaper if we were started without
        # an active window so that the animation is skipped
        set_original_wallpaper "$wallpaper_mode"
      fi
      prev_blank="$blank"
    fi

    first_run=0
    sleep "$POLL_INTERVAL"
  done
}


ensure_feh() {
  if ! command -v feh >/dev/null; then
    echo "$BIN requires Feh to set wallpapers."
    exit
  fi
}


# Ensure that 'graphicsmagick' is available.
ensure_gm() {
  if ! command -v gm >/dev/null; then
    echo "$BIN requires GraphicsMagick to set wallpapers."
    exit
  fi
}

ensure_wmctrl() {
  if ! command -v wmctrl >/dev/null; then
    echo "$BIN requires wmctrl to detect events."
    exit
  fi
}

print_usage() {
  head "Monitoring changes"
  info "$BIN will now blur any wallpapers set using 'feh'."
  info "To change your wallpaper, try:"
  info ""
  info "    feh --bg-tile your-image.jpg"
}

# Perform cleanup operations before stopping.
do_cleanup () {
  # Guard clause so that it's only ran once
  if [[ "$CLEANING_UP" == "1" ]]; then return; fi
  CLEANING_UP=1

  rm -rf "$CACHE_DIR"

  # Restore original wallpaper before exiting
  if [[ "$MODE" == "foreground" ]] && [[ -e "$HOME/.fehbg" ]]; then
    head "Restoring original wallpaper"
    source "$HOME/.fehbg"
  fi
}

finish () {
  do_cleanup
  exit 1
}

main() {
  ensure_feh
  ensure_gm
  ensure_wmctrl
  ensure_rofi
  parse_opts "$@"

  case "$MODE" in
    background)
      kill_other_instances
      print_usage
      "$0" --worker --quiet & disown

      head "Background mode"
      info "$BIN started in background mode!"
      info "To stop, use '$BIN --stop'."
      ;;
  
    stop)
      kill_other_instances
      ;;

    noop)
      exit
      ;;

    *)
      kill_other_instances
      print_usage
      run_loop
      ;;
  esac
}

trap finish EXIT
trap finish SIGHUP
trap finish SIGINT
trap finish SIGTERM
main "$@"