#!/bin/bash

set -e

# === CONFIGURATION ===
SCRIPT_NAME="battery_alert.sh"
PLIST_NAME="com.user.batteryalert.plist"
TARGET_SCRIPT_PATH="$HOME/$SCRIPT_NAME"
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
TARGET_PLIST_PATH="$LAUNCH_AGENT_DIR/$PLIST_NAME"
STATE_FILE="$HOME/.battery_state"

echo "🧹 Uninstalling Battery Alert for user: $USER"

# === 1. Unload and remove LaunchAgent ===
if [ -f "$TARGET_PLIST_PATH" ]; then
    echo "🔻 Unloading LaunchAgent..."
    launchctl unload "$TARGET_PLIST_PATH" 2>/dev/null || true

    echo "🗑️  Removing LaunchAgent plist: $TARGET_PLIST_PATH"
    rm "$TARGET_PLIST_PATH"
else
    echo "ℹ️ LaunchAgent plist not found at $TARGET_PLIST_PATH (already removed?)"
fi

# === 2. Remove battery script ===
if [ -f "$TARGET_SCRIPT_PATH" ]; then
    echo "🗑️  Removing script: $TARGET_SCRIPT_PATH"
    rm "$TARGET_SCRIPT_PATH"
else
    echo "ℹ️ Script not found at $TARGET_SCRIPT_PATH (already removed?)"
fi

# === 3. Remove state file ===
if [ -f "$STATE_FILE" ]; then
    echo "🗑️  Removing state file: $STATE_FILE"
    rm "$STATE_FILE"
else
    echo "ℹ️ State file not found at $STATE_FILE (already removed?)"
fi

echo "✅ Battery Alert has been fully uninstalled."
