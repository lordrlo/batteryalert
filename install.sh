#!/bin/bash

set -e

# === CONFIGURATION ===
SCRIPT_NAME="battery_alert.sh"
PLIST_NAME="com.user.batteryalert.plist"
TARGET_SCRIPT_PATH="$HOME/$SCRIPT_NAME"
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
TARGET_PLIST_PATH="$LAUNCH_AGENT_DIR/$PLIST_NAME"

echo "🔧 Installing Battery Alert for user: $USER"

# === 1. Check & copy the battery script ===
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "❌ Error: $SCRIPT_NAME not found in the current directory."
    exit 1
fi

cp "$SCRIPT_NAME" "$TARGET_SCRIPT_PATH"
chmod +x "$TARGET_SCRIPT_PATH"
echo "✅ Copied $SCRIPT_NAME to $TARGET_SCRIPT_PATH"

# === 2. Ensure LaunchAgents directory exists ===
mkdir -p "$LAUNCH_AGENT_DIR"

# === 3. Prepare the plist with the correct path ===
if [ ! -f "$PLIST_NAME" ]; then
    echo "❌ Error: $PLIST_NAME not found in the current directory."
    exit 1
fi

# Replace placeholder path with real absolute path to script
sed "s|/FULL/PATH/TO/battery_alert.sh|$TARGET_SCRIPT_PATH|g" "$PLIST_NAME" > "$TARGET_PLIST_PATH"
echo "✅ Installed $PLIST_NAME to $TARGET_PLIST_PATH"

# === 4. Load (or reload) the LaunchAgent ===
launchctl unload "$TARGET_PLIST_PATH" 2>/dev/null || true
launchctl load "$TARGET_PLIST_PATH"
echo "✅ LaunchAgent loaded successfully"

echo "🎉 Battery alert is now active and will run every 5 minutes."
