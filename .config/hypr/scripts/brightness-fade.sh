#!/bin/bash

set -euo pipefail

show_usage() {
    cat << EOF
Usage: $0 TARGET_BRIGHTNESS [OPTIONS]

Set screen brightness with smooth transitions.

Arguments:
  TARGET_BRIGHTNESS          Target brightness (0-100)
                             Examples: 50, 25, 100

Options:
  -t, --target VALUE         Target brightness (alternative to positional argument)
  -d, --duration MILLISECONDS
                             Duration of transition in milliseconds (default: 1000)
  -c, --curve TYPE           Transition curve type: linear, ease-in, ease-out,
                             ease-in-cubed, ease-out-cubed (default: ease-in-cubed)
  -e, --device DEVICE        Backlight device name (default: intel_backlight)
  -q, --quiet FLAG           Hide progress bar (default: false)
  -h, --help                 Show this help message

Examples:
  $0 50                      Set brightness to 50% with 1 second ease-in-cubed
                             transition
  $0 -t 75 -d 2500           Set brightness to 75% over 2.5 seconds
  $0 -c ease-out -t 30       Set brightness to 30% with slow end curve transition
  $0 --device acpi_video0 25
                             Set brightness of acpi_video0 device to 25%

Note: Requires brightnessctl and proper permissions (usually in 'video' group)
EOF
}

TARGET_BRIGHTNESS=""
DURATION="1000"
CURVE="ease-in-cubed"
DEVICE="intel_backlight"
QUIET=false

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
            CURVE="$2"  # linear, ease-in, ease-out
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

# Validate arguments
if [[ -z "$TARGET_BRIGHTNESS" ]]; then
    echo "Error: Missing required arguments"
    show_usage
    exit 1
fi
VALID_CURVES="linear ease-in ease-out ease-in-cubed ease-out-cubed"
if ! [[ "$VALID_CURVES" =~ "$CURVE" ]]; then
    echo "Error: Invalid curve '$CURVE'. Vaild: $VALID_CURVES"
    exit 1
fi

# Validate dependences
if ! command -v brightnessctl &> /dev/null; then
    echo "Error: brightnessctl is not installed"
    exit 1
fi

readonly PRESSISION=1000
readonly CURRENT=$(brightnessctl --device="$DEVICE" get)
readonly MAX=$(brightnessctl --device="$DEVICE" max)
readonly TARGET=$((TARGET_BRIGHTNESS * MAX / 100))
readonly DIFF=$((TARGET - CURRENT))

# Already at target
if [ $DIFF -eq 0 ]; then
    exit 0
fi

progress_bar() {
    if $QUIET; then
        return 0
    fi

    local step=$1
    local total_steps=$2
    local value=$3

    local readonly BAR_LENGTH=20
    local filled=$((step * BAR_LENGTH / total_steps))
    local empty=$((BAR_LENGTH - filled))
    if [ $empty -eq 0 ]; then
        printf "\r[%-*s] %d" "$BAR_LENGTH" "$(printf '#%.0s' $(seq 1 $BAR_LENGTH))" "$value"
    else
        printf "\r[%-*s] %d" "$BAR_LENGTH" "$(printf '#%.0s' $(seq 1 $filled))$(printf ' %.0s' $(seq 1 $empty))" "$value"
    fi
}

get_eased_diff() {
    local diff=$1
    local i=$2
    local s=$3

    case $CURVE in
        ease-in)
            # Quadratic ease-in: progress²
            # (i/steps)²
            local t=$((PRESSISION * i*i / (s*s)))
            diff=$((diff * t / PRESSISION))
            ;;
        ease-out)
            # Quadratic ease-out: 1 - (1-progress)²
            # 1 - (1 - i/s)²
            # 1 - (1 - 2i/s + i²/s²) # (a - b)² = a² - 2ab + b²
            # 1 -  1 + 2i/s - i²/s²
            # 2i/s - i²/s²
            # 2i*s/s² - i²/s²
            # (2i*s - i²)/s²
            local t=$((PRESSISION * (2*i*s - i*i) / (s*s)))
            diff=$((diff * t / PRESSISION))
            ;;
        ease-in-cubed)
            # Quadratic ease-in: progress³
            # (i/steps)³
            local t=$((PRESSISION * i*i*i / (s*s*s)))
            diff=$((diff * t / PRESSISION))
            ;;
        ease-out-cubed)
            # Cubic ease-out: 1 - (1-progress)³
            # 1 - (1 - i/s)³
            # 1 - (1 - 3i/s + 3i²/s² - i³/s³) # (a - b)³ = a³ - 3a²b + 3ab² - b³
            # 1 -  1 + 3i/s - 3i²/s² + i³/s³
            # 3i/s - 3i²/s² + i³/s³
            # 3is²/s³ - 3i²s/s³ + i³/s³
            # (3is² - 3i²s + i³)/s³
            local t=$((PRESSISION * (3*i*s*s - 3*i*i*s + i*i*i) / (s*s*s)))
            diff=$((diff * t / PRESSISION))
            ;;
        linear|*)
            diff=$((diff * i / s))
            ;;
    esac

    echo $diff
}

readonly STEPS_PER_SECOND=40
STEPS=$((DURATION * STEPS_PER_SECOND / 1000))
if [ $STEPS -eq 0 ]; then
    STEPS=1
fi
STEP_SIZE=$((DIFF / STEPS))
STEP_DELAY="$(awk "BEGIN {print 1 / $STEPS_PER_SECOND}")"

# Ensure change on small DIFF
if [ $STEP_SIZE -eq 0 ]; then
    STEP_SIZE=$((DIFF > 0 ? 1 : -1))
fi

fade() {
    local steps=$STEPS
    local current=$CURRENT

    for ((i=0; i<steps; i++)); do
        local eased_change=$(get_eased_diff $DIFF $i $steps)
        current=$((CURRENT + eased_change))

        if [ $current -lt 0 ]; then
            current=0
        elif [ $current -gt $MAX ]; then
            current=$MAX
        fi

        brightnessctl --device="$DEVICE" set "$current" > /dev/null
        progress_bar $i $steps $current

        sleep $STEP_DELAY
    done

    brightnessctl --device="$DEVICE" set "$TARGET" > /dev/null
    progress_bar $STEPS $STEPS $TARGET
}

fade

# TODO add the remaining ease functions from https://nicmulvaney.com/easing/
