#!/usr/bin/env bash

# set -euo pipefail

monitor="eDP-2"
# Change the following variables to your environment and preference
destination_base_dir="$HOME/Pictures/wallpapers/static/rated"
# The symbolic link that will be generated after the image is copied
link_path="$HOME/.local/state/wpaperd/wallpapers/$monitor"
follow_link_when_not_found=1
allow_rating_outside_1_to_10_range=1
get_image_path_from_wallpaper_service() {
    wpaperctl get "$monitor"
}
get_custom_mapped_dir_name() {
    local kb_custom="$1"
    case "$kb_custom" in
        12)
            local custom_dir_name="../very-sketched"
            ;;
        13)
            local custom_dir_name="../sketched"
            ;;
        14)
            local custom_dir_name="../to-upscale"
            ;;
        *)
            throw "Unmapped kb-custom '$kb_custom'"
            ;;
    esac
    echo $custom_dir_name
}
get_time_left(){
    raw_time_left=$(wpaperctl status)
    log "raw_time_left = '$raw_time_left'"
    formated_time_left=$(echo "$raw_time_left" | awk -F '[()]' '{print $2}')
    log "time_left = '$formated_time_left'"
    echo $formated_time_left
}

# Helpers
log() {
    echo ${@:2} "$1">&2
}
log_error() {
    local RED='\033[0;31m'
    local NO_COLOR='\033[0m'
    log "${RED}$1${NO_COLOR}" -e
}
notify() {
    notify-send ${@:2} -a "Wallpaper Rating Script" "Wallpaper Rating" "$1"
}
throw() {
    log_error "Error: $1"
    notify "Error: $1" -u critical
    kill -TERM $$
    exit 1
}

rofi_retv="${ROFI_RETV:-0}"
log "ROFI_RETV = $rofi_retv"
echo -en "\0use-hot-keys\x1ftrue\n"
echo -en "\0prompt\x1fRate Wallpaper\n"

# First pass at launch
if [ $rofi_retv -eq 0 ] || [ $rofi_retv -eq 1 ]; then
    log "first pass"
    image_path_from_wallpaper_service=$(get_image_path_from_wallpaper_service)
    log "image_path_from_wallpaper_service = '$image_path_from_wallpaper_service'"
    if [ -f "$image_path_from_wallpaper_service" ]; then
        current_image_path=$image_path_from_wallpaper_service
    else
        log_error "Image not found at '$image_path_from_wallpaper_service'"
        log "Following link at '$link_path'"
        current_image_path=$(readlink -f "$link_path")
    fi
    current_filename=$(basename "$current_image_path")
    current_dir_name=$(basename "$(dirname "$current_image_path")")
    formated_time_left=$(get_time_left)
    log "current_base_name = '$current_filename'"
    log "current_dir_name = '$current_dir_name'"
    log "time_left = '$formated_time_left'"

    echo "Rate Wallpaper: '$current_filename'"
    echo -en "\0prompt\x1fRate: '$current_filename'\n"
    echo -en "\0theme\x1ftextbox-current-rating { markup: true; }\n"
    echo -en "\0theme\x1ftextbox-current-rating { content: \"<span style='italic'>$current_dir_name</span>\"; }\n"
    echo -en "\0theme\x1ftextbox-time-left { markup: true; }\n"
    echo -en "\0theme\x1ftextbox-time-left { content: \"<span alpha='30%' font_size='xx-small'>$formated_time_left</span>\"; }\n"

    exit 0
fi

# Second pass at input
get_valid_current_image_path() {
    local image_path="$(get_image_path_from_wallpaper_service)"
    if [[ $follow_link_when_not_found ]] && [[ -z "$image_path" || ! -f "$image_path" ]]; then
        log_error "Image not found at '$image_path'"
        log "following link"
        local image_path=$(readlink -f "$link_path")
    fi
    if [ -z "$image_path" ] ; then
        throw "Empty image path '$image_path'"
    fi
    if [ ! -f "$image_path" ]; then
        throw "Image file not found at path: \r'$image_path'"
    fi
    echo $image_path
}
get_dest_dir_name() {
    # We expect the `kb_custom` to `rating` to be inverted in the theme
    # rating 10 = kb-custom-1 // rating 0 = kb-custom-11
    local rating=$(($kb_custom))
    log "rating = '$rating'"
    local is_rating_within_1_to_10_range=$((1 <= rating && rating <= 10))
    if (( is_rating_within_1_to_10_range )); then
        local padded_rating=$(printf '%02d' "$rating")
        local dest_dir_name="quality-$padded_rating"
    elif (( $allow_rating_outside_1_to_10_range )); then
        local dest_dir_name=$(get_custom_mapped_dir_name "$kb_custom")
    else
        throw "Unknown error with kb-custom '$kb_custom'"
    fi
    echo $dest_dir_name
}

minimum_rofi_retv_kb_custom=10
# kb-custom-N is base 1, so we add 1
kb_custom=$(($rofi_retv - $minimum_rofi_retv_kb_custom + 1))
log "kb_custom = '$kb_custom'"
if (($kb_custom < 1)); then
    throw "Unhandled kb-custom '$kb_custom'"
fi
kb_custom_is_within_allowed_range=$(( allow_rating_outside_1_to_10_range || kb_custom - 1 <= 10 ))
if (( ! kb_custom_is_within_allowed_range )) ; then
    throw "kb-custom '$kb_custom' outside allowed range; Set \`allow_rating_outside_0_to_10_range\` to \`true\`"
fi

current_image_path=$(get_valid_current_image_path)
log "current_image_path = '$current_image_path'"
dir_name=$(get_dest_dir_name)
log "dir_name = '$dir_name'"
filename=$(basename "$current_image_path")
log "filename = '$filename'"
fullpath="$destination_base_dir/$dir_name/$filename"
log "fullpath = '$fullpath'"

log "creating directory '$(dirname "$fullpath")'"
mkdir -p "$(dirname "$fullpath")" || throw "Failed to create directory"
log "moving '$current_image_path' to '$fullpath'"
mv "$current_image_path" "$fullpath" || throw "Failed to move '$current_image_path' to '$fullpath'"
log "creating linking directory '$(dirname "$link_path")'"
mkdir -p "$(dirname "$link_path")" || throw "Failed to create link directory"
log "linking '$link_path' to '$fullpath'"
ln -sf "$fullpath" "$link_path" || throw "Failed to link '$fullpath' to '$link_path'"

log "Wallpaper rated '$dir_name'"
notify "Wallpaper rated '$dir_name'" -u low

log "end of script"
exit 0
