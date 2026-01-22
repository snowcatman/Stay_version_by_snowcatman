#!/bin/bash
#
# Stay Script - Linux Version (Improved)
# Description: Opens a new terminal window and runs a command, keeping the window open
# Author: snowcatman
# Version: 2.0

# Function to show usage
show_usage() {
    echo "Stay - Linux Version"
    echo "Usage: Stay-linux.sh <command>"
    echo ""
    echo "Examples:"
    echo "  Stay-linux.sh echo 'Hello World'"
    echo "  Stay-linux.sh ls -la"
    echo "  Stay-linux.sh python script.py"
    echo ""
    echo "This will open a new terminal window, run your command,"
    echo "and keep the window open for you to view the results."
}

# Function to detect available terminal emulators
detect_terminal() {
    local terminals=("gnome-terminal" "konsole" "xterm" "xfce4-terminal" "mate-terminal" "lxterminal")
    
    for terminal in "${terminals[@]}"; do
        if command -v "$terminal" >/dev/null 2>&1; then
            echo "$terminal"
            return 0
        fi
    done
    
    return 1
}

# Function to execute command in new window
execute_stay_command() {
    local command="$1"
    
    if [ -z "$command" ]; then
        show_usage
        exit 1
    fi
    
    # Detect available terminal
    local terminal=$(detect_terminal)
    if [ $? -ne 0 ]; then
        echo "Error: No supported terminal emulator found."
        echo "Please install one of: gnome-terminal, konsole, xterm, xfce4-terminal, mate-terminal, lxterminal"
        exit 1
    fi
    
    echo "Stay: Using terminal: $terminal"
    
    # Create a temporary script file
    local temp_script="/tmp/stay_temp_$$.sh"
    
    # Build the script content
    cat > "$temp_script" << EOF
#!/bin/bash
# Stay Temporary Script for Linux

echo "Running command: $command"
echo "----------------------------------------"

# Execute the command
eval "$command"
local exit_code=$?

echo "----------------------------------------"
if [ \$exit_code -eq 0 ]; then
    echo "Command completed successfully!"
else
    echo "Command failed with exit code \$exit_code"
fi

echo ""
echo "Press any key to exit..."
read -n 1

# Clean up
rm -f "$temp_script"
EOF
    
    # Make the temporary script executable
    chmod +x "$temp_script"
    
    # Execute based on terminal type
    case "$terminal" in
        "gnome-terminal")
            gnome-terminal -- bash -c "\"$temp_script\"" 2>/dev/null &
            ;;
        "konsole")
            konsole -e bash "$temp_script" 2>/dev/null &
            ;;
        "xterm")
            xterm -e bash "$temp_script" 2>/dev/null &
            ;;
        "xfce4-terminal")
            xfce4-terminal -e bash "$temp_script" 2>/dev/null &
            ;;
        "mate-terminal")
            mate-terminal -e bash "$temp_script" 2>/dev/null &
            ;;
        "lxterminal")
            lxterminal -e bash "$temp_script" 2>/dev/null &
            ;;
        *)
            echo "Error: Unsupported terminal: $terminal"
            rm -f "$temp_script"
            exit 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo "Stay: New terminal window opened with your command."
    else
        echo "Error: Failed to open new terminal window."
        rm -f "$temp_script"
        exit 1
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

# Join all arguments into a single command string
full_command="$*"

# Check for help flags
case "$full_command" in
    -h|--help|help)
        show_usage
        exit 0
        ;;
esac

echo "Stay: Opening new terminal window..."
execute_stay_command "$full_command"
