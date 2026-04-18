#!/bin/bash

SCRIPT_DIR=$HOME/.config/hypr/scripts

is_on_battery() {
    if [[ "$(cat /sys/class/power_supply/AC/online)" == "0" ]]; then
        echo true
    else
        echo false
    fi
}

echo "is_on_battery = $(is_on_battery)"
if [[ $(is_on_battery) == true ]]; then
    $SCRIPT_DIR/power-mode/set-power-mode.sh power-save
else
    $SCRIPT_DIR/power-mode/set-power-mode.sh standard
fi
