#!/bin/bash

# Script to help copy files from container to host
echo "=== Samba Home Share - Copy to Host ==="
echo ""
echo "Run these commands from your Linux host (outside this container):"
echo ""

# Get container ID
CONTAINER_ID=$(hostname)
echo "1. Copy files from this container:"
echo "   mkdir -p ~/samba-home-share"
echo "   docker cp $CONTAINER_ID:/home/node/. ~/samba-home-share/"
echo ""

echo "2. Navigate to the directory:"
echo "   cd ~/samba-home-share"
echo ""

echo "3. Make scripts executable:"
echo "   chmod +x *.sh"
echo ""

echo "4. Initialize git repository:"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial Samba home share container with automatic port assignment'"
echo ""

echo "5. Create GitHub repository and push:"
echo "   # First create a new repository on GitHub named 'samba-home-share'"
echo "   # Then run:"
echo "   git remote add origin https://github.com/ismpower/samba-home-share.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""

echo "6. Deploy on any machine:"
echo "   git clone https://github.com/ismpower/samba-home-share.git"
echo "   cd samba-home-share"
echo "   chmod +x *.sh"
echo "   ./build.sh && ./run.sh"
echo ""

echo "Container ID: $CONTAINER_ID"
echo "Current path: /home/node"
echo ""
echo "Files ready for GitHub:"
ls -la /home/node/