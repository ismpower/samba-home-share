# Deployment Guide

## For New Machines

1. **Install Docker** (if not already installed):
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install docker.io
   sudo usermod -aG docker $USER
   # Log out and back in for group changes
   
   # Alpine
   sudo apk add docker
   sudo service docker start
   sudo addgroup $USER docker
   ```

2. **Clone and Deploy**:
   ```bash
   git clone <your-repo-url>
   cd samba-home-share
   chmod +x *.sh
   ./build.sh
   ./run.sh
   ```

3. **Verify Deployment**:
   ```bash
   docker ps | grep samba-home-share
   docker logs samba-home-share
   ```

## Windows Connection

1. Open File Explorer
2. In address bar, type: `\\<machine-ip>\home`
3. Example: `\\10.10.10.55\home`
4. You should see your Linux home directory

## Port Reference Table

| IP Range | Port Slots | Example IPs → Ports |
|----------|------------|-------------------|
| .50-.59  | 1-10       | .50→1139/1445, .55→6139/6445 |
| .60-.69  | 11-20      | .60→11139/11445, .65→16139/16445 |
| .70-.79  | 21-30      | .70→21139/21445, .75→26139/26445 |
| .80      | 31         | .80→31139/31445 |

## Multiple Container Management

If you need multiple Samba shares on one machine:
```bash
# Copy project to different directory
cp -r samba-home-share samba-docs-share
cd samba-docs-share

# Edit run.sh to use different container name and mount point
# Change: --name samba-home-share to --name samba-docs-share
# Change: -v "$CURRENT_HOME:/shared-home" to -v "/path/to/docs:/shared-home"
```

## Security Notes

- Only IPs 10.10.10.50-80 can access
- No password required (secured by IP restriction)
- Files maintain Linux user ownership
- Container restarts automatically with system