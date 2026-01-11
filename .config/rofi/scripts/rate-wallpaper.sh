#!/usr/bin/env bash

# Change the following variables to your environment and preference
destination_parent_dir="$HOME/Pictures/wallpapers/static/rated"
monitor="eDP-2"
# The symbolic link that will be generated after the image is copied
link_path="$HOME/.local/state/wpaperd/wallpapers/$monitor"
get_image_path_from_wallpaper_service() {
    wpaperctl get "$monitor"
}


set -euo pipefail

# With optional echo options
log() {
    echo ${@:2} "$1">&2
}
throw() {
    RED='\033[0;31m'
    NO_COLOR='\033[0m'
    log "${RED}$1${NO_COLOR}" -e
    notify "$1" -u critical
    exit 1
}
notify() {
    notify-send ${@:2} -a "Wallpaper Rating Script" "Wallpaper Rating" "$1"
}

kb_custom="${ROFI_RETV:-0}"
log "kb_custom = $kb_custom"
echo -en "\0use-hot-keys\x1ftrue\n"
echo -en "\0prompt\x1fRate Wallpaper\n"
echo -en "\0keep-filter\x1ftrue\n"


if [ $kb_custom -eq 0 ] || [ $kb_custom -eq 1 ]; then
    log "first pass"
    current_image_path=$(get_image_path_from_wallpaper_service)
    log "current_image_path = $current_image_path"
    current_image_name=$(basename "$current_image_path")
    log "current_image_name = $current_image_name"
    current_rating=$(basename $(dirname "$current_image_path"))
    log "current_rating = $current_rating"

    echo "Rate Wallpaper: '$current_image_name'"
    echo -en "\0prompt\x1fRate: '$current_image_name'\n"
    echo -en "\0theme\x1ftextbox-current-rating { content: \"$current_rating\"; }\n"
    exit 0
fi

minimum_kb_custom=10
rating=$((10 - ($kb_custom - $minimum_kb_custom)))
is_rating_outside_0_to_10_range=$((rating < 0 || rating > 10))
if (( is_rating_outside_0_to_10_range )) ; then
    throw "error: Unhandled kb-custom"
fi

log "Button pressed = $rating"

get_valid_current_image_path() {
    image_path="$(get_image_path_from_wallpaper_service)"
    if [ -z "$image_path" ] ; then
        throw "error: Empty image path '$image_path'"
    fi
    if [ ! -f "$image_path" ]; then
        throw "error: Image file not found at path: \r'$image_path'"
    fi
    echo "$image_path"
}

current_image_path=$(get_valid_current_image_path)
padded_rating=$(printf '%02d' "$rating")
dest_path="$destination_parent_dir/quality-$padded_rating/$(basename "$current_image_path")"
dest_dir=$(dirname "$dest_path")
link_dir=$(dirname "$link_path")
log "current_image_path = $current_image_path"
log "link_path = $link_path"
log "padded_rating = $padded_rating"
log "dest_path = $dest_path"
log "dest_dir = $dest_dir"
log "link_path = $link_path"

log "creating directory '$dest_dir'"
mkdir -p "$dest_dir" || throw "Failed to create directory"
log "moving '$current_image_path' to '$dest_path'"
mv "$current_image_path" "$dest_path" || throw "Failed to move '$current_image_path' to '$dest_path'"
log "creating linking directory '$link_dir'"
mkdir -p "$link_dir" || throw "Failed to create link directory"
log "linking '$link_path' to '$dest_path'"
ln -sf "$dest_path" "$link_path" || throw "Failed to link '$dest_path' to '$link_path'"

log "Wallpaper rated '$rating'"
notify "Wallpaper rated '$rating'"

log "end of script"
exit 0
