#!/bin/bash

# Build script for Samba Home Share Container
echo "Building Samba Home Share Docker image..."

# Build the Docker image
docker build -t samba-home-share:latest .

echo "Build complete! Image tagged as: samba-home-share:latest"
echo ""
echo "To run the container, use: ./run.sh"