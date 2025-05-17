# Stay Script Documentation

## Overview
The Stay script is a utility that opens a new terminal window to run commands, allowing you to continue working in your current terminal while monitoring long-running processes.

## Current Version (Debug)
The current version includes extensive debug output to help diagnose issues with D-Bus and terminal window creation.

## Key Components

### Debug Function
```bash
debug() {
    echo "DEBUG: $*" >&2
}
```
- Outputs debug messages to stderr
- Used throughout the script to track execution flow

### D-Bus Launch Detection
```bash
find_dbus_launch() {
    # Checks multiple locations for dbus-launch
    # Returns path if found, empty if not found
}
```
- Searches for dbus-launch in:
  - Current PATH
  - /usr/bin/dbus-launch
  - /bin/dbus-launch
  - /usr/local/bin/dbus-launch

### Environment Handling
```bash
get_user_env() {
    # Gets critical environment variables
    # Handles both sudo and non-sudo cases
}
```
- Preserves important environment variables:
  - DISPLAY
  - XAUTHORITY
  - DBUS_SESSION_BUS_ADDRESS
  - PATH

### Main Logic
1. Checks if running with sudo
2. Gets user environment
3. Locates dbus-launch
4. Creates temporary script with:
   - Environment setup
   - PATH configuration
   - D-Bus session initialization
   - Terminal window creation
5. Executes script with sudo
6. Cleans up temporary files

## Current Issues
From debug output:
1. dbus-launch not found in any location
2. D-Bus session initialization failing
3. Terminal window creation failing

## Debug Output Example
```
DEBUG: Running with sudo privileges
DEBUG: Getting user environment...
DEBUG: Running as sudo, getting environment for user snowcatman
DEBUG: User environment: PATH=/home/snowcatman/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
DEBUG: Searching for dbus-launch...
DEBUG: Checking PATH for dbus-launch...
DEBUG: Checking common locations...
DEBUG: Checking /usr/bin/dbus-launch
DEBUG: Checking /bin/dbus-launch
DEBUG: Checking /usr/local/bin/dbus-launch
DEBUG: dbus-launch not found in any location
```

## Next Steps
1. Investigate why dbus-launch is not found
2. Consider alternative approaches to D-Bus session handling
3. Explore different terminal emulators
4. Research system-level D-Bus configuration

## Dependencies
- bash
- gnome-terminal
- dbus-launch (currently missing)
- sudo

## Usage
```bash
# Regular command
Stay "your-command"

# With sudo
sudo Stay "your-command"
``` 