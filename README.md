# Stay Script

A cross-platform utility that opens a new terminal window, runs a command, and keeps the terminal open after the command completes.

## 🚀 Multi-Platform Support

**NEW: Now works on Windows, macOS, and Linux!**

- **Linux**: `Stay-linux.sh` - Improved version with terminal auto-detection
- **macOS**: `Stay-mac.sh` - Native Terminal.app support  
- **Windows**: `Stay.ps1` (PowerShell) and `Stay.bat` (CMD)
- **Universal**: `Stay` - Auto-detects OS and launches appropriate version

**Original Linux version with D-Bus support**: `Stay.sh` (still available for advanced users)

## Features

- Opens a new terminal window
- Executes the specified command
- Keeps the terminal window open after command completion
- Works in both user and root environments
- Handles GUI permissions correctly in all environments

## Usage

### Universal (Recommended)
```bash
# Works on all platforms
./Stay echo "Hello World"
./Stay ls -la
./Stay python script.py
```

### Platform-Specific
```bash
# Linux (improved version)
./Stay-linux.sh echo "Hello World"

# macOS
./Stay-mac.sh echo "Hello World"

# Windows PowerShell
.\Stay.ps1 echo "Hello World"

# Windows CMD
Stay.bat echo "Hello World"

# Original Linux (D-Bus version)
./Stay.sh echo "Hello World"
```

### Quick Examples
```bash
Stay echo "Hello World"
Stay python server.py
Stay npm start
Stay make build
```

## Environment Handling

The script handles three different execution environments:

### 1. Regular User
- Directly opens `gnome-terminal` with the command
- Uses the current user's environment variables
- No special handling required

### 2. Partial Root Environment (`sudo su`)
- Maintains access to the original user's environment variables
- Constructs the D-Bus session address using the user's UID
- Uses the current environment's `DISPLAY` and `XAUTHORITY` variables
- Launches `gnome-terminal` with the user's environment

### 3. Full Root Environment (`sudo -i`)
- Retrieves all necessary environment variables using `loginctl`
- Gets the user's session information, X authority, and display settings
- Constructs the D-Bus session address using the user's UID
- Launches `gnome-terminal` with the correct user environment

## Technical Details

### Environment Variables
The script handles these key environment variables:
- `DISPLAY`: X11 display server
- `XAUTHORITY`: X11 authority file
- `DBUS_SESSION_BUS_ADDRESS`: D-Bus session address

### D-Bus Session
- Constructed as `unix:path=/run/user/<uid>/bus`
- Ensures GUI applications can communicate with the session bus
- Works in both partial and full root environments

### Temporary Files
- Created in the user's home directory
- Properly owned and permissioned for the target user
- Automatically cleaned up after use

## Installation

### Universal Installation
1. Download all files to your preferred directory
2. Add the directory to your PATH
3. Use `Stay` command from anywhere

### Platform-Specific Installation

**Linux/macOS:**
```bash
# Universal launcher
sudo cp Stay /usr/local/bin/
sudo chmod +x /usr/local/bin/Stay

# Or platform-specific
sudo cp Stay-linux.sh /usr/local/bin/Stay
sudo chmod +x /usr/local/bin/Stay
```

**Windows PowerShell:**
```powershell
# Add to PATH or copy to system directory
$env:PATH += ";C:\path\to\stay"
```

**Windows CMD:**
```cmd
# Add to PATH or copy to system directory
set PATH=%PATH%;C:\path\to\stay
```

## Requirements

### Universal Requirements
- Basic shell environment (bash, PowerShell, or CMD)

### Platform-Specific Requirements

**Linux:**
- Any terminal emulator (gnome-terminal, konsole, xterm, xfce4-terminal, mate-terminal, lxterminal)
- Bash shell

**macOS:**
- Terminal.app
- osascript (built-in)

**Windows:**
- PowerShell 5.0+ (for .ps1 version)
- CMD (for .bat version)

**Original Linux Version (Stay.sh):**
- Bash shell
- `gnome-terminal`
- `loginctl` (for root environment handling)
- D-Bus session support

## Recent Improvements

### Version 2.0 - Multi-Platform Release
- ✅ **Cross-platform support**: Windows, macOS, Linux
- ✅ **Universal launcher**: Auto-detects operating system
- ✅ **No D-Bus dependency**: Improved Linux version with fallback terminals
- ✅ **Windows native support**: PowerShell and CMD versions
- ✅ **macOS integration**: Native Terminal.app support
- ✅ **Better error handling**: Clear messages and cleanup
- ✅ **Terminal auto-detection**: Finds available terminals on Linux

### Version 1.0 - Original Linux Version
- Added support for full root environment (`sudo -i`)
- Improved D-Bus session handling
- Better environment variable management
- More reliable session detection
- Automatic cleanup of temporary files

## Troubleshooting

### Universal Issues
- Ensure the script has execute permissions (Linux/macOS)
- Check that the target directory is in your PATH
- Verify you're using the correct script for your platform

### Linux Issues
```bash
# If no terminal found, install one:
sudo apt install gnome-terminal  # Ubuntu/Debian
sudo dnf install gnome-terminal  # Fedora
```

### macOS Issues
```bash
# If osascript fails, check Terminal permissions:
# System Preferences > Security & Privacy > Privacy > Automation
```

### Windows Issues
```powershell
# Enable PowerShell scripts:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Original Linux Version (D-Bus Issues)
If you encounter D-Bus errors with `Stay.sh`:
1. Use the improved `Stay-linux.sh` instead
2. Ensure you have the required dependencies installed
3. Check that the script has execute permissions
4. Verify that you're using a supported terminal emulator
5. Check the system logs for any D-Bus or X11 errors

For detailed troubleshooting, see `errors.md` and `README-MultiPlatform.md`.

## Development History

### Version 1.0
- Initial implementation focusing on opening new terminal windows
- Support for both regular and sudo commands
- Automatic terminal emulator detection
- Command output preservation
- User-friendly completion messages

## Requirements

- A terminal emulator (preferably one of: gnome-terminal, xterm, konsole, terminator)
- Bash shell
- Basic system utilities

## Future Improvements

Potential areas for enhancement:
- Add command timeout options
- Implement command status reporting
- Add support for more terminal emulators
- Include command history in the new window
- Add configuration file support

## Contributing

Feel free to submit issues and enhancement requests! 

## Original Script Inspiration

```stay.sh
#!/usr/bin/env bash
#
# Script name: stay
# Description: Opens terminal and runs a command and stays open.
# Dependencies: dtos-settings
# GitLab: https://www.gitlab.com/dtos/dtos-settings/
# License: https://www.gitlab.com/dtos/dtos-settings/
# Contributors: Derek Taylor

source "$HOME"/.config/dtos-settings/dtos.conf

$DTOSTERM -e bash -c "$*; echo -e; tput setaf 5 bold; \
    read -p 'Press any key to exit ' -s -n 1"
```

What I am also wanting is to need no extra dependencies. 

## GUI Permissions and Environment Variables

The script's behavior in different root environments is primarily determined by how GUI permissions and environment variables are handled:

### Required GUI Environment Variables
- `DISPLAY`: Specifies the X server connection
- `XAUTHORITY`: Contains the X authentication credentials
- `DBUS_SESSION_BUS_ADDRESS`: Required for desktop integration

### How Different Root Methods Affect GUI Access

1. **Partial Root (`sudo su`)**
   - Preserves all GUI environment variables
   - Maintains X server connection
   - Keeps D-Bus session access
   - Allows direct use of `gnome-terminal`

2. **Full Root (`sudo -i`)**
   - Resets all environment variables
   - Loses X server connection
   - Loses D-Bus session
   - Requires switching to original user for GUI access

3. **Direct Sudo (`sudo Stay`)**
   - Preserves necessary environment variables
   - Maintains GUI access
   - Works with current session

This is why the script behaves differently in each case - it's adapting to the available GUI permissions and environment variables.


