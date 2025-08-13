#!/bin/bash

set -e  # Exit on error

# Get the UID, GID, and USER from the host (passed as environment variables or default to current user)
HOST_UID=${USER_ID:-$(id -u)}
HOST_GID=${GROUP_ID:-$(id -g)}
USERNAME=${USERNAME:-dockeruser}  # Fallback to 'dockeruser' if USERNAME is unset
echo "HOST_UID=$USER_ID, HOST_GID=$GROUP_ID, USERNAME=$USERNAME"

# Check if the group exists, if not create it
if ! getent group "$HOST_GID" > /dev/null; then
    echo "Creating group with GID $HOST_GID and name $USERNAME"
    groupadd -g "$HOST_GID" "$USERNAME" || { echo "Failed to create group"; exit 1; }
else
    GROUPNAME=$(getent group "$HOST_GID" | cut -d: -f1)
    echo "Using existing group $GROUPNAME with GID $HOST_GID"
fi

# Check if the user exists, if not create it
if ! id -u "$HOST_UID" > /dev/null 2>&1; then
    echo "Creating user $USERNAME with UID $HOST_UID and GID $HOST_GID"
    useradd -u "$HOST_UID" -g "$HOST_GID" -m -s /bin/bash "$USERNAME" || { echo "Failed to create user"; exit 1; }
else
    EXISTING_USERNAME=$(id -un "$HOST_UID" 2>/dev/null || echo "$USERNAME")
    echo "User with UID $HOST_UID exists as $EXISTING_USERNAME, updating group to $HOST_GID"
    usermod -g "$HOST_GID" "$EXISTING_USERNAME" || { echo "Failed to update user group"; exit 1; }
    USERNAME="$EXISTING_USERNAME"
fi

# Ensure home directory permissions
echo "Setting ownership of /home/$USERNAME to $HOST_UID:$HOST_GID"
mkdir -p /home/"$USERNAME"
chown "$HOST_UID":"$HOST_GID" /home/"$USERNAME" || { echo "Failed to set home directory permissions"; exit 1; }

# Execute the command as the specified user
echo "Executing command: $@"
exec "$@" || { echo "Failed to execute command"; exit 1; }

