#!/bin/bash

power_mode=$1
STANDARD="standard"
POWER_SAVE="power-save"
HYPR_CONF_DIR="$HOME/.config/hypr"

if [[ $power_mode == "" ]]; then
    echo "No options given for power mode"
    echo "Options accepted [ $STANDARD | $POWER_SAVE ]"
    exit 1
fi

if [[ $power_mode != "$STANDARD" && $power_mode != "$POWER_SAVE" ]]; then
    echo "Unknown command '$power_mode'"
    echo "Options accepted [ $STANDARD | $POWER_SAVE ]"
    exit 1
fi

set_hyprland_environment_variables() {
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr/" 2>/dev/null | head -n1)
}

notify_power_mode() {
    hyprctl notify -1 3000 "rgb(ff1ea3)" "Power Mode: $1"
}

set_power_mode() {
    local power_mode=$1
    if [[ $power_mode == $POWER_SAVE ]]; then
        # hyprctl keyword decoration:blur:enabled false # > /dev/null
        # hyprctl keyword decoration:shadow:enabled false # > /dev/null
        hyprctl keyword source $HYPR_CONF_DIR/config/variables/battery-save.conf
        notify_power_mode "Switched to Battery (Power Save)" # > /dev/null
    elif [[ $power_mode == $STANDARD ]]; then
        # hyprctl keyword decoration:blur:enabled true # > /dev/null
        # hyprctl keyword decoration:shadow:enabled true # > /dev/null
        hyprctl keyword source $HYPR_CONF_DIR/config/variables/init.conf
        notify_power_mode "Switched to AC (Standard)" # > /dev/null
    fi
}

set_hyprland_environment_variables
echo "power_mode = $power_mode"
set_power_mode $power_mode
