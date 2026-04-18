#!/bin/bash

display=$1
wallpaper=$2
default_display="eDP-2"

echo "Display is : $display"
if (( $display != $default_display )); then
    echo "Skipped matugen on display '$display'"
    exit 0
fi

echo "Wallpaper path is: $wallpaper"

# Update Matugen
echo ":: Applying matugen with $wallpaper"
matugen image $wallpaper --show-colors -t scheme-tonal-spot --contrast 0
echo ":: Applied matugen with $wallpaper"
