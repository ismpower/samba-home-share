#!/bin/bash

# Startup script for flexible Samba container
echo "Starting Samba Home Share Container..."

# Get environment variables (with defaults)
SAMBA_USER=${SAMBA_USER:-"shareuser"}
SAMBA_UID=${SAMBA_UID:-1000}
SAMBA_GID=${SAMBA_GID:-1000}

echo "Configuring user: $SAMBA_USER (UID:$SAMBA_UID, GID:$SAMBA_GID)"

# Create group if it doesn't exist
if ! getent group $SAMBA_GID > /dev/null 2>&1; then
    addgroup -g $SAMBA_GID sharegroup
fi

# Create user if it doesn't exist
if ! getent passwd $SAMBA_USER > /dev/null 2>&1; then
    adduser -D -u $SAMBA_UID -G sharegroup $SAMBA_USER
fi

# Set ownership of the shared directory to match the user
chown -R $SAMBA_UID:$SAMBA_GID /shared-home

# Update the Samba configuration with the actual user
sed -i "s/guest account = .*/guest account = $SAMBA_USER/" /etc/samba/smb.conf
sed -i "s/force user = .*/force user = $SAMBA_USER/" /etc/samba/smb.conf
sed -i "s/force group = .*/force group = sharegroup/" /etc/samba/smb.conf

# Create Samba user (no password needed since we allow guest access)
echo "Setting up Samba user..."
adduser -D -s /bin/false $SAMBA_USER 2>/dev/null || true
echo -e "\n" | smbpasswd -a $SAMBA_USER -s

# Create log directory
mkdir -p /var/log/samba

# Start Samba services
echo "Starting Samba daemon..."
smbd --foreground --log-stdout --no-process-group