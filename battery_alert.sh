#!/bin/bash

battery_info=$(pmset -g batt)
battery_level=$(echo "$battery_info" | grep -Eo '\d+%' | tr -d '%')
charging=$(echo "$battery_info" | grep "AC Power")

STATE_FILE="$HOME/.battery_state"

low_alerted=0
high_alerted=0

if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
fi

notify() {
    /bin/launchctl asuser "$(id -u "$USER")" sudo -u "$USER" /opt/homebrew/bin/terminal-notifier \
      -title "Battery Alert" -message "$1" -sender com.apple.systempreferences
}

if [ "$battery_level" -lt 20 ]; then
    if [ "$low_alerted" -ne 1 ]; then
        notify "🪫 Battery is below 20%"
        low_alerted=1
        high_alerted=0
    fi
elif [ "$battery_level" -gt 80 ] && [[ "$charging" == *"AC Power"* ]]; then
    if [ "$high_alerted" -ne 1 ]; then
        notify "🔋 Battery is above 80%"
        high_alerted=1
        low_alerted=0
    fi
else
    low_alerted=0
    high_alerted=0
fi

echo "low_alerted=$low_alerted" > "$STATE_FILE"
echo "high_alerted=$high_alerted" >> "$STATE_FILE"
