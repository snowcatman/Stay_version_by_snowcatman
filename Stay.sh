#!/bin/bash
#
# Script name: Stay
# Description: Opens terminal and runs a command and stays open.
# Contributors: Derek Taylor (original and his contributors), Modified for general use by snowcatman Via Cussor AI: gemini-2.5-flash-preview-04-17
# As of May 17 2025

# Create the command script
create_temp_script() {
    local temp_script="$1"
    cat > "$temp_script" << 'EOF'
#!/bin/bash
eval "$*"
echo -e "\033[0;32mPress any key to exit...\033[0m"
read -n 1
EOF
    chmod +x "$temp_script"
}

# Get user's D-Bus session
get_dbus_session() {
    local user="$1"
    echo "unix:path=/run/user/$(id -u "$user")/bus"
}

# Main execution
if [ "$(id -u)" -eq 0 ]; then
    # Determine user and environment
    if [ -n "$SUDO_USER" ]; then
        USER="$SUDO_USER"
        DBUS_SESSION=$(get_dbus_session "$USER")
        ENV_VARS="DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION"
    else
        USER=$(who am i | awk '{print $1}')
        SESSION_ID=$(loginctl show-user "$USER" | grep Display | cut -d= -f2)
        if [ -z "$SESSION_ID" ]; then
            echo "Error: Could not get session for user $USER"
            exit 1
        fi
        XAUTH=$(loginctl show-session "$SESSION_ID" | grep XAuthority | cut -d= -f2)
        DISP=$(loginctl show-session "$SESSION_ID" | grep Display | cut -d= -f2)
        DBUS_SESSION=$(get_dbus_session "$USER")
        ENV_VARS="DISPLAY=$DISP XAUTHORITY=$XAUTH DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION"
    fi
    
    # Create and run temp script
    TEMP_SCRIPT="$(getent passwd "$USER" | cut -d: -f6)/.stay_temp_$$.sh"
    create_temp_script "$TEMP_SCRIPT"
    chown "$USER:$USER" "$TEMP_SCRIPT"
    su - "$USER" -c "$ENV_VARS gnome-terminal -- bash -c '\"$TEMP_SCRIPT\" \"$*\"; rm \"$TEMP_SCRIPT\"'" 2>/dev/null &
else
    # Regular user execution
    TEMP_SCRIPT="$HOME/.stay_temp_$$.sh"
    create_temp_script "$TEMP_SCRIPT"
    gnome-terminal -- bash -c "\"$TEMP_SCRIPT\" \"$*\"; rm \"$TEMP_SCRIPT\"" 2>/dev/null &
fi 