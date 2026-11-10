#!/bin/bash
# Escalating bedtime nag: every step makes the screen worse until you get off the computer.
# The level is written to a state file that config/bedtime.lua reads on every config load,
# so Hyprland reloads keep it applied.

set -euo pipefail

readonly FALLBACK_START="01:00" # Starts on its own if `bedtime.sh start` wasn't run
readonly RESET_AT="12:00"       # A new night begins here; the previous night's state is dropped
readonly STEP_MINUTES=10
readonly MAX_LEVEL=4
readonly TICK_SECONDS=60
readonly OFF_CODE_BASE_LENGTH=16
readonly OFF_CODE_LENGTH_PER_LEVEL=8

readonly STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/bedtime"
readonly NIGHT_FILE="$STATE_DIR/night" # "<night> <start epoch>" or "<night> off"
readonly LEVEL_FILE="$STATE_DIR/level"
readonly DAEMON_LOCK="$STATE_DIR/daemon.lock"
readonly PATCH="$HOME/.config/hypr/config/bedtime.lua"

show_usage() {
    cat << EOF
Usage: $0 COMMAND

Commands:
  start     Start tonight's escalation now (e.g. right after taking melatonin)
  off       Stop for tonight; asks you to type a random code
  status    Show tonight's state and current level
  tick      Recompute the level once and apply it if it changed
  daemon    Run tick every $TICK_SECONDS seconds (started from autostart.lua)

Levels advance every $STEP_MINUTES minutes after start:
  1  notification, refresh rate lowered to 60Hz
  2  grayscale
  3  dim grayscale, animations off
  4  dim, washed-out grayscale, reminder repeats every step

Without 'start', the escalation begins on its own at $FALLBACK_START.
A new night begins at $RESET_AT.
EOF
}

seconds_of_day() {
    local hours minutes
    IFS=: read -r hours minutes <<< "$1"
    echo $((10#$hours * 3600 + 10#$minutes * 60))
}

readonly RESET_OFFSET=$(seconds_of_day "$RESET_AT")
readonly FALLBACK_OFFSET=$(seconds_of_day "$FALLBACK_START")

# The night is named after the date it started on, shifted so it changes at RESET_AT
current_night() {
    date -d "@$(($(date +%s) - RESET_OFFSET))" +%F
}

seconds_into_night() {
    local now_offset
    now_offset=$(seconds_of_day "$(date +%H:%M)")
    echo $(((now_offset - RESET_OFFSET + 86400) % 86400))
}

is_past_fallback_start() {
    local fallback_into_night=$(((FALLBACK_OFFSET - RESET_OFFSET + 86400) % 86400))
    [[ $(seconds_into_night) -ge $fallback_into_night ]]
}

# Prints the start epoch, "off", or nothing when tonight has no state yet
read_night_state() {
    [[ -f "$NIGHT_FILE" ]] || return 0
    local night state
    read -r night state < "$NIGHT_FILE"
    if [[ "$night" == "$(current_night)" ]]; then
        echo "$state"
    fi
}

write_night_state() {
    mkdir -p "$STATE_DIR"
    echo "$(current_night) $1" > "$NIGHT_FILE"
}

compute_level() {
    local state
    state=$(read_night_state)
    if [[ -z "$state" || "$state" == "off" ]]; then
        echo 0
        return
    fi
    local elapsed=$(($(date +%s) - state))
    local level=$((elapsed / (STEP_MINUTES * 60) + 1))
    echo $((level > MAX_LEVEL ? MAX_LEVEL : level))
}

applied_level() {
    if [[ -f "$LEVEL_FILE" ]]; then
        cat "$LEVEL_FILE"
    else
        echo 0
    fi
}

notify_level() {
    local level=$1
    case $level in
        1) notify-send -a bedtime "Bedtime" "Wrap up. The screen gets worse every $STEP_MINUTES minutes." ;;
        2) notify-send -a bedtime "Bedtime" "Grayscale now. Save what you're doing." ;;
        3) notify-send -a bedtime "Bedtime" "Dimming. Write down where you stopped." ;;
        *) notify-send -a bedtime -u critical "Bedtime" "Put the laptop away and grab the Kindle." ;;
    esac
}

apply_level() {
    local level=$1
    mkdir -p "$STATE_DIR"
    echo "$level" > "$LEVEL_FILE"
    if [[ $level -eq 0 ]]; then
        # Going back to normal needs the full config, which no longer applies any level
        hyprctl reload > /dev/null
    else
        hyprctl eval "dofile('$PATCH')" > /dev/null
        notify_level "$level"
    fi
}

seconds_since_level_applied() {
    echo $(($(date +%s) - $(stat -c %Y "$LEVEL_FILE")))
}

cmd_tick() {
    if [[ -z "$(read_night_state)" ]] && is_past_fallback_start; then
        write_night_state "$(date +%s)"
    fi

    local level previous
    level=$(compute_level)
    previous=$(applied_level)
    if [[ $level -ne $previous ]]; then
        apply_level "$level"
    elif [[ $level -eq $MAX_LEVEL && $(seconds_since_level_applied) -ge $((STEP_MINUTES * 60)) ]]; then
        touch "$LEVEL_FILE"
        notify_level "$level"
    fi
}

cmd_start() {
    local state
    state=$(read_night_state)
    if [[ -n "$state" && "$state" != "off" ]]; then
        echo "Already running since $(date -d "@$state" +%H:%M)"
        return
    fi
    write_night_state "$(date +%s)"
    cmd_tick
}

generate_code() {
    local length=$1
    local chars="abcdefghjkmnpqrstuvwxyz23456789" # No look-alike characters
    local code=""
    for ((i = 0; i < length; i++)); do
        code+=${chars:RANDOM % ${#chars}:1}
    done
    echo "$code"
}

cmd_off() {
    local level
    level=$(compute_level)
    if [[ $level -eq 0 ]]; then
        echo "Not running"
        return
    fi

    local code typed
    code=$(generate_code $((OFF_CODE_BASE_LENGTH + OFF_CODE_LENGTH_PER_LEVEL * level)))
    typed=$(rofi -dmenu -p "Type the code to stop bedtime" -mesg "$code" < /dev/null || true)
    if [[ "$typed" != "$code" ]]; then
        notify-send -a bedtime "Bedtime" "Wrong code. Still on."
        exit 1
    fi
    write_night_state "off"
    cmd_tick
}

cmd_status() {
    local state
    state=$(read_night_state)
    case $state in
        "") echo "Not started tonight (fallback at $FALLBACK_START)" ;;
        off) echo "Turned off tonight" ;;
        *) echo "Running since $(date -d "@$state" +%H:%M), level $(compute_level)/$MAX_LEVEL" ;;
    esac
}

cmd_daemon() {
    mkdir -p "$STATE_DIR"
    exec 9> "$DAEMON_LOCK"
    if ! flock -n 9; then
        echo "Daemon already running"
        exit 0
    fi
    while true; do
        cmd_tick || true
        sleep "$TICK_SECONDS"
    done
}

case ${1:-} in
    start) cmd_start ;;
    off) cmd_off ;;
    status) cmd_status ;;
    tick) cmd_tick ;;
    daemon) cmd_daemon ;;
    -h | --help) show_usage ;;
    *)
        show_usage
        exit 1
        ;;
esac
