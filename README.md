# Battery Alert for macOS

A tiny LaunchAgent-based service for macOS that sends a native notification when:

- 🔻 Battery drops **below 20%**
- 🔺 Battery goes **above 80% while charging**

Handy if you like to keep your battery in a healthy range without constantly checking the menu bar.

---

## Requirements

- macOS
- [Homebrew](https://brew.sh/)
- `terminal-notifier`:

  ```bash
  brew install terminal-notifier
  ```

By default, Homebrew on Apple Silicon installs it to `/opt/homebrew/bin/terminal-notifier`, which is the path used in `battery_alert.sh`.  
If it’s installed somewhere else, either:

- Edit `battery_alert.sh` and change the path in the `notify()` function, or
- Create a symlink into `/opt/homebrew/bin`.

---

## Installation

1. Clone or copy this project to a folder on your Mac.
2. In Terminal, from inside that folder:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

You should see a final message like:

```text
🎉 Battery alert is now active and will run every 5 minutes.
```

---

## Uninstall

From the project folder:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

---

## How it works

- Uses `pmset -g batt` to read the current battery percentage and power source.
- Sends notifications via [`terminal-notifier`](https://github.com/julienXX/terminal-notifier)  
  (by default at `/opt/homebrew/bin/terminal-notifier`).
- Remembers whether it already warned you using a small state file:

  ```text
  ~/.battery_state
  ```

  This avoids spamming you with the same notification:

  - When battery goes < 20%, you get **one** notification until it goes back above 20%.
  - When battery is > 80% **and plugged in (AC Power)**, you get **one** notification until conditions change.

- A `LaunchAgent` plist runs the script periodically (every **5 minutes**) in the background.

Files:

- `battery_alert.sh` – main check-and-notify script.
- `com.user.batteryalert.plist` – LaunchAgent definition.
- `install.sh` – installs and activates the service for the current user.
- `uninstall.sh` – removes the service for the current user.

---

## Notes & Customization

- **Thresholds**  
  You can edit `battery_alert.sh` and change the values `20` and `80` to any percentages you like.

- **Notification text / title**  
  Customize the messages inside the `notify()` function if you want different wording or emojis.

- **Different notification tool**  
  If you prefer another notification mechanism, replace the `terminal-notifier` call in `notify()` with your own command.

Happy battery-nerding 🔋
