# Termux Zsh Setup

A lightweight, automated script to transform your Termux shell into a powerful Zsh environment. It features a beautiful mobile-friendly prompt, smart autosuggestions, and Manjaro-style status indicators.

## Features

* **Automated Install:** Installs `zsh`, `git`, and necessary plugins.
* **Smart Prompt:**
    * **Path Shortening:** Automatically shortens deep directory paths (e.g., `~/.../parent/current`) to keep your terminal clean.
    * **Visual Status:** Displays a green check (✔) for success or red error codes on the right side.
    * **Execution Timer:** Automatically shows how long a command took if it runs for longer than 30 seconds.
* **Productivity Plugins:**
    * **Syntax Highlighting:** Colorizes commands as you type to prevent errors.
    * **Autosuggestions:** Suggests commands based on your history (press `→` to accept).
* **Enhanced Navigation:**
    * **Smart Tab Completion:** Case-insensitive matching with an interactive selection menu.
    * **History Search:** Type a command snippet and press `Up`/`Down` to filter history.

## 📦 Installation

1.  Copy the `setup.sh` script to your Termux home directory.
2.  Make it executable and run it:

```bash
chmod +x setup.sh
./setup.sh
```

The script will automatically switch your shell to Zsh upon completion.

The aliases at the end are just basic general useful ones which you can edit or delete.
