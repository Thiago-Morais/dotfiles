#!/bin/bash

display=$1
wallpaper=$2

echo "Display is : $display"
echo "Wallpaper path is: $wallpaper"

# Update Matugen
echo ":: Applying matugen with $wallpaper"
matugen image $wallpaper --show-colors -t scheme-tonal-spot --contrast 0
