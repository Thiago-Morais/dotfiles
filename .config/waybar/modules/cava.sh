#! /bin/bash

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
# 30 bars seems to be a great number for smooth visualization without being too wide
bars = 30

framerate = 60

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii

# Change this match length of the 'bar' variable in the awk below.
# A bigger number then the length will be cropped to the last character.
# A smaller number will not use all characters
ascii_max_range = 13

[smoothing]
monstercat = 1
waves = 0

noise_reduction = 18
" > $config_file

# We added extra characters to optimize vertical space on smaller bars

cava -p $config_file | awk -F';' -v bar="  ▁▂▃▄▅▆▆▇▇██" '
{
    max = length(bar) - 1
    for (i=1; i<=NF-1; i++) {
        idx = ($i > max) ? max : $i
        printf "%s", substr(bar, idx+1, 1)
    }
    printf "\n"
    fflush()
}'

# The thinnerst/narrowerst font I could find for this was the "FantasqueSansM Nerd Font Mono"
# Be sure to add this to your style.css
# #custom-cava {
#   font-family: FantasqueSansM Nerd Font Mono;
# }

