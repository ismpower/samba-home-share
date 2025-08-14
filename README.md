# Samba Home Share Docker Container

A secure, multi-machine Samba container that automatically shares user home directories with Windows machines on your network. Designed for home labs and small networks with automatic port management and security restrictions.

## 🔒 Security Features

- **IP Range Restriction**: Only allows connections from 10.10.10.50-80
- **Network Isolation**: Blocks control devices (.80-.100) and house network (.100+)
- **Automatic Port Assignment**: Each machine gets unique ports based on IP address
- **Guest Access**: No passwords required (secured by IP restrictions)

## 📦 What's Included

- **Dockerfile**: Alpine Linux-based Samba server
- **smb.conf**: Secure Samba configuration 
- **start.sh**: Dynamic user setup and Samba startup
- **build.sh**: Simple build script
- **run.sh**: Intelligent deployment script with automatic port assignment

## 🚀 Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ismpower/samba-home-share.git
   cd samba-home-share
   ```

2. **Build the container**:
   ```bash
   chmod +x build.sh run.sh
   ./build.sh
   ```

3. **Deploy on your machine**:
   ```bash
   ./run.sh
   ```

4. **Connect from Windows**:
   - Open File Explorer
   - Go to `\\<machine-ip>\home`
   - Access your entire home directory with read/write permissions

## 🌐 Port Assignment System

The container automatically assigns unique ports based on your machine's IP address:

| Machine IP | Assigned Ports | Windows Path |
|------------|---------------|--------------|
| 10.10.10.50 | 1139/1445 | `\\10.10.10.50\home` |
| 10.10.10.60 | 11139/11445 | `\\10.10.10.60\home` |
| 10.10.10.70 | 21139/21445 | `\\10.10.10.70\home` |
| 10.10.10.80 | 31139/31445 | `\\10.10.10.80\home` |

*Formula: Port = (LastOctet - 49) × 1000 + [139/445]*

## 🔧 Requirements

- **Docker installed** on your Linux machine
- **Machine IP**: Must be in range 10.10.10.50 - 10.10.10.80
- **Network Access**: Windows machines must be able to reach your Linux machine

## 📋 Container Management

```bash
# View container status
docker ps | grep samba-home-share

# View logs
docker logs samba-home-share

# Stop container
docker stop samba-home-share

# Restart container
docker restart samba-home-share

# Redeploy (stops, removes, and starts fresh)
./run.sh
```

## 🛡️ Network Security

**Allowed Access:**
- IP Range: 10.10.10.50 - 10.10.10.80 only
- Protocols: SMB/CIFS (ports 139/445)

**Blocked Access:**
- Control devices: 10.10.10.80 - 10.10.10.100
- House network: 10.10.10.100+
- All other networks

## 🔍 Troubleshooting

**Container won't start:**
```bash
# Check if ports are in use
netstat -tuln | grep -E ":(1139|1445|2139|2445)"

# View container logs
docker logs samba-home-share
```

**Can't connect from Windows:**
1. Verify your machine IP is in allowed range (10.10.10.50-80)
2. Check if Windows firewall is blocking SMB
3. Try `\\<ip>\home` instead of computer name
4. Verify container is running: `docker ps`

**Permission issues:**
- The container automatically matches your Linux user permissions
- Files created from Windows will have correct ownership

## 🏗️ Architecture

```
Windows PC (10.10.10.xx) 
    ↓ (SMB Protocol)
Docker Container (Port xxxx:139/445)
    ↓ (Volume Mount)
Linux Host (/home/user)
```

## 📁 File Structure

```
samba-home-share/
├── Dockerfile          # Container build instructions
├── smb.conf            # Samba configuration
├── start.sh            # Container startup script
├── build.sh            # Build helper script
├── run.sh              # Deployment script
└── README.md           # This documentation
```

---

**Created for home lab environments with multiple Linux machines requiring secure Windows file sharing.**