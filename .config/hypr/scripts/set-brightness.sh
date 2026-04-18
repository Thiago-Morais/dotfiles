#!/bin/bash

set -euo pipefail

TARGET_BRIGHTNESS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--target)
            TARGET_BRIGHTNESS="$2"
            shift 2
            ;;
        -d|--duration)
            DURATION="$2"
            shift 2
            ;;
        -c|--curve)
            CURVE="$2"
            shift 2
            ;;
        -e|--device)
            DEVICE="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=true
            shift 1
            ;;
        -*)
            echo "Error: Unknown option $1"
            show_usage
            exit 1
            ;;
        *)
            if [[ -z "$TARGET_BRIGHTNESS" ]]; then
                TARGET_BRIGHTNESS=$1
            elif [[ -z "$DURATION" ]]; then
                DURATION=$1
            elif [[ -z "$CURVE" ]]; then
                CURVE=$1
            elif [[ -z "$DEVICE" ]]; then
                DEVICE=$1
            else
                echo "Error: Too many arguments"
                show_usage
                exit 1
            fi
            shift
            ;;
    esac
done


# brightnessctl -l -c backlight|grep -oP "Device '\K[^']+"|xargs -I {} brightnessctl -e -d {} s +4%
# brightnessctl -l -c backlight|grep -oP "Device '\K[^']+"|xargs -I {} brightnessctl -e -d {} s 4%-

format_relative_brightnessctl() {
    local readonly input=$1
    if [[ "$input" =~ ^([0-9]+)([+-])$ ]]; then
        local number="${BASH_REMATCH[1]}"
        local sign="${BASH_REMATCH[2]}"
        if [[ "$sign" == "+" ]]; then
            echo "+$number%"
        else
            echo "$number%-"
        fi
    else
        echo "$input"
    fi
}

format_relative_ddcutil() {
    local readonly input=$1
    if [[ "$input" =~ ^([0-9]+)([+-])$ ]]; then
        local number="${BASH_REMATCH[1]}"
        local sign="${BASH_REMATCH[2]}"
        echo "$sign $number"
    else
        echo "$input"
    fi
}

set_internal_brightness() {
    DEVICE="intel_backlight"
    TARGET=$(format_relative_brightnessctl $TARGET_BRIGHTNESS)
    brightnessctl --device="$DEVICE" set "$TARGET" > /dev/null
}

set_external_brightness() {
    VCP_CODE=10
    BUS=1
    DEVICE_STRING="-b $BUS"
    AMOUNT=$(format_relative_ddcutil $TARGET_BRIGHTNESS)
    # ddcutil setvcp $DEVICE_STRING $VCP_CODE $AMOUNT
    ddcutil setvcp $DEVICE_STRING 10 $AMOUNT
    ddcutil setvcp $DEVICE_STRING 12 $AMOUNT
}

set_internal_brightness
set_external_brightness
