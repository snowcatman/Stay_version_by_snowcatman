# Stay Script

A Bash script that opens a terminal window, runs a command, and keeps the terminal open after the command completes.

## Features

- Opens a new terminal window
- Executes the specified command
- Keeps the terminal window open after command completion
- Works in both user and root environments
- Handles GUI permissions correctly in all environments

## Usage

```bash
Stay <command>
```

Example:
```bash
Stay echo "Hello World"
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

1. Copy the script to `/usr/local/bin/`:
```bash
sudo cp stay-bck003.sh /usr/local/bin/Stay
```

2. Make it executable:
```bash
sudo chmod +x /usr/local/bin/Stay
```

## Requirements

- Bash shell
- `gnome-terminal`
- `loginctl` (for root environment handling)

## Recent Improvements

- Added support for full root environment (`sudo -i`)
- Improved D-Bus session handling
- Better environment variable management
- More reliable session detection
- Automatic cleanup of temporary files

## Troubleshooting

If you encounter issues:
1. Ensure you have the required dependencies installed
2. Check that the script has execute permissions
3. Verify that you're using a supported terminal emulator
4. Check the system logs for any D-Bus or X11 errors

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


