#!/bin/bash
#
# Stay Script - macOS Version
# Description: Opens a new Terminal window and runs a command, keeping the window open
# Author: snowcatman
# Version: 1.0

# Function to show usage
show_usage() {
    echo "Stay - macOS Version"
    echo "Usage: Stay-mac.sh <command>"
    echo ""
    echo "Examples:"
    echo "  Stay-mac.sh echo 'Hello World'"
    echo "  Stay-mac.sh ls -la"
    echo "  Stay-mac.sh python script.py"
    echo ""
    echo "This will open a new Terminal window, run your command,"
    echo "and keep the window open for you to view the results."
}

# Function to execute command in new window
execute_stay_command() {
    local command="$1"
    
    if [ -z "$command" ]; then
        show_usage
        exit 1
    fi
    
    # Create a temporary script file
    local temp_script="/tmp/stay_temp_$$.sh"
    
    # Build the script content
    cat > "$temp_script" << EOF
#!/bin/bash
# Stay Temporary Script for macOS

echo "Running command: $command"
echo "----------------------------------------"

# Execute the command
eval "$command"
local exit_code=$?

echo "----------------------------------------"
if [ $exit_code -eq 0 ]; then
    echo "Command completed successfully!"
else
    echo "Command failed with exit code $exit_code"
fi

echo ""
echo "Press any key to exit..."
read -n 1

# Clean up
rm -f "$temp_script"
EOF
    
    # Make the temporary script executable
    chmod +x "$temp_script"
    
    # Use osascript to open Terminal with the script
    if command -v osascript >/dev/null 2>&1; then
        osascript -e "tell application \"Terminal\" to do script \"$temp_script\"" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Stay: New Terminal window opened with your command."
        else
            echo "Error: Failed to open new Terminal window."
            rm -f "$temp_script"
            exit 1
        fi
    else
        echo "Error: osascript not found. Cannot open new Terminal window."
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

echo "Stay: Opening new Terminal window..."
execute_stay_command "$full_command"
