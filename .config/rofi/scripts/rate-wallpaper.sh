#!/usr/bin/env bash

# Rating = kb-custom
# 10 = 1
# 9  = 2
# 8  = 3
# 7  = 4
# 6  = 5
# 5  = 6

kb_custom="${ROFI_RETV:-0}"
echo "kb_custom = $kb_custom">&2
echo -en "\0use-hot-keys\x1ftrue\n"
echo -en "\0prompt\x1fRate Wallpaper\n"
echo -en "\0keep-filter\x1ftrue\n"

if [ $kb_custom -eq 0 ] || [ $kb_custom -eq 1 ]; then
    echo "first pass">&2
    echo "Rate Wallpaper"
    exit 0
fi

minimum_kb_custom=10
rating=$((10 - ($kb_custom - $minimum_kb_custom)))
is_rating_outside_0_to_10_range=$((rating < 0 || rating > 10))
if (( is_rating_outside_0_to_10_range )) ; then
    echo "error: Unhandled kb-custom">&2
    exit 1
fi

echo "Button pressed = $rating">&2

get_current_image_path() {
    image_path=$(wpaperctl get eDP-2)
    if [ -z $image_path ] || [ ! -f $image_path ]; then
        echo "error: Invalid image path">&2
        exit 1
    fi
    echo $image_path
}

current_image_path=$(get_current_image_path)
link_path="$HOME/.local/state/wpaperd/wallpapers/eDP-2"
padded_rating=$(printf '%02d' "$rating")
target_path="$HOME/Pictures/wallpapers/static/rated/quality-$padded_rating/$(basename $current_image_path)"
target_dir=$(dirname $target_path)
echo "current_image_path = $current_image_path">&2
echo "link_path = $link_path">&2
echo "padded_rating = $padded_rating">&2
echo "target_path = $target_path">&2
echo "target_dir = $target_dir">&2

echo "creating directory '$target_dir'">&2
mkdir -p $target_dir
echo "moving '$current_image_path' to '$target_path'">&2
# mv "$current_image_path" "$target_path"
echo "linking '$link_path' to '$target_path">&2
# ln -sf $target_path $link_path

echo "Wallpaper rated '$rating'">&2
notify-send "Wallpaper rated '$rating'"

echo "end of script">&2
exit 0
