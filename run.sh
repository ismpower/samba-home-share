#!/bin/bash

# Run script for Samba Home Share Container
# Supports IP range 10.10.10.50 to 10.10.10.80 (31 slots total)

# Get current user info
CURRENT_USER=$(whoami)
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)
CURRENT_HOME=$HOME

# Get machine IP and calculate port slot
MACHINE_IP=$(hostname -I | awk '{print $1}')
LAST_OCTET=$(echo $MACHINE_IP | cut -d'.' -f4)

# Calculate port slot (IP ending .50 = slot 1, .51 = slot 2, etc.)
# Supports IPs from .50 to .80 (31 slots total)
if [ $LAST_OCTET -ge 51 ] && [ $LAST_OCTET -le 90 ]; then
    PORT_SLOT=$((LAST_OCTET - 49))  # .51 becomes slot 1, .52 becomes slot 2, etc.
else
    echo "ERROR: IP $MACHINE_IP is outside allowed range (10.10.10.51 - 10.10.10.90)"
    echo "This prevents access from control devices (.90-.100) and house network (.100+)"
    exit 1
fi

# Calculate actual ports
SMB_PORT=$((PORT_SLOT * 1000 + 139))     # 1139, 2139, 3139, etc.
CIFS_PORT=$((PORT_SLOT * 1000 + 445))    # 1445, 2445, 3445, etc.

echo "======================================"
echo "Samba Home Share Container Setup"
echo "======================================"
echo "Machine IP: $MACHINE_IP"
echo "Port Slot: $PORT_SLOT (based on IP ending .$LAST_OCTET)"
echo "Assigned Ports: $SMB_PORT (SMB) / $CIFS_PORT (CIFS)"
echo "User: $CURRENT_USER (UID: $CURRENT_UID, GID: $CURRENT_GID)"
echo "Home Directory: $CURRENT_HOME"
echo ""

# Stop any existing container
echo "Stopping any existing samba-home-share container..."
docker stop samba-home-share 2>/dev/null || true
docker rm samba-home-share 2>/dev/null || true

# Check if ports are available
if command -v netstat >/dev/null 2>&1; then
    if netstat -tuln | grep -q ":$SMB_PORT "; then
        echo "ERROR: Port $SMB_PORT is already in use!"
        exit 1
    fi
    if netstat -tuln | grep -q ":$CIFS_PORT "; then
        echo "ERROR: Port $CIFS_PORT is already in use!"
        exit 1
    fi
fi

# Run the container
echo "Starting Samba container with ports $SMB_PORT:139 and $CIFS_PORT:445..."
docker run -d \
  --name samba-home-share \
  --restart unless-stopped \
  -p $SMB_PORT:139 \
  -p $CIFS_PORT:445 \
  -p $((SMB_PORT-2)):137/udp \
  -p $((SMB_PORT-1)):138/udp \
  -v "$CURRENT_HOME:/shared-home" \
  -e SAMBA_USER="$CURRENT_USER" \
  -e SAMBA_UID="$CURRENT_UID" \
  -e SAMBA_GID="$CURRENT_GID" \
  samba-home-share:latest

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Container started successfully!"
    echo ""
    echo "Windows Connection Info:"
    echo "========================"
    echo "Network Path: \\\\$MACHINE_IP\\home"
    echo "Ports: $SMB_PORT (SMB) / $CIFS_PORT (CIFS)"
    echo ""
    echo "Security: Only accessible from IPs 10.10.10.50-80"
    echo "Blocked: Control devices (.80-.100) and house network (.100+)"
    echo ""
    echo "Management Commands:"
    echo "==================="
    echo "Stop:    docker stop samba-home-share"
    echo "Logs:    docker logs samba-home-share" 
    echo "Restart: docker restart samba-home-share"
    echo ""
    echo "Port Reference Examples:"
    echo "IP .50 → 1139/1445    IP .65 → 16139/16445"
    echo "IP .55 → 6139/6445    IP .70 → 21139/21445" 
    echo "IP .60 → 11139/11445  IP .80 → 31139/31445"
else
    echo "❌ Failed to start container!"
    exit 1
fi
