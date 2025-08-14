# Use Alpine Linux as base - it's small and secure
FROM alpine:latest

# Install Samba server
RUN apk add --no-cache samba bash

# Create a user 'winnay' that matches your Linux user
# This ensures file permissions work correctly
RUN adduser -D -s /bin/bash winnay

# Create directory for Samba configuration
RUN mkdir -p /etc/samba

# Copy our custom Samba configuration
COPY smb.conf /etc/samba/smb.conf

# Copy our startup script
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# Expose Samba ports
# 139: NetBIOS Session Service
# 445: SMB over TCP
EXPOSE 139 445

# Run our startup script when container starts
CMD ["/start.sh"]
