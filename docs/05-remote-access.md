# Remote Access Configuration

## SSH Access

### Basic SSH Setup
Already covered in security section, but here's a quick reference:

```bash
# Generate SSH key pair on client
ssh-keygen -t ed25519 -C "your.email@example.com"

# Copy public key to server
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@server-ip

# Connect
ssh username@server-ip

# Or with custom port
ssh -p 2222 username@server-ip
```

### SSH Tunneling for Secure Port Forwarding

#### Local Port Forwarding
Forward a local port to a remote service:
```bash
# Access remote database locally
ssh -L 5432:localhost:5432 username@server-ip

# Now connect to localhost:5432 to access remote PostgreSQL
```

#### Remote Port Forwarding
Expose local service to remote server:
```bash
# Make local web app accessible from remote server
ssh -R 8080:localhost:3000 username@server-ip

# Remote server can now access your local app on port 8080
```

#### Dynamic Port Forwarding (SOCKS Proxy)
```bash
# Create SOCKS proxy on port 1080
ssh -D 1080 -C -N username@server-ip

# Configure browser to use localhost:1080 as SOCKS proxy
```

### SSH Configuration File
Create `~/.ssh/config` for easier connections:

```
# ~/.ssh/config

Host geekom
    HostName 192.168.1.100
    Port 2222
    User yourusername
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host geekom-public
    HostName your.public.ip.address
    Port 2222
    User yourusername
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
```

Now connect with: `ssh geekom`

## VNC (Virtual Network Computing)

### TigerVNC Server Setup

```bash
# Install TigerVNC server
sudo apt install -y tigervnc-standalone-server tigervnc-common

# Set VNC password (run as user, not root)
vncpasswd

# Create xstartup file
mkdir -p ~/.vnc
nano ~/.vnc/xstartup
```

Sample xstartup for Ubuntu with GNOME:
```bash
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
export XDG_MENU_PREFIX="gnome-flashback-"
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
gnome-session --session=gnome-flashback-metacity --disable-acceleration-check &
```

Make executable:
```bash
chmod +x ~/.vnc/xstartup
```

Start VNC server:
```bash
# Start on display :1 (port 5901) with 1920x1080 resolution
vncserver :1 -geometry 1920x1080 -depth 24

# List running sessions
vncserver -list

# Kill session
vncserver -kill :1
```

### VNC as a Service

Create systemd service for VNC:
```bash
sudo nano /etc/systemd/system/vncserver@.service
```

Content:
```ini
[Unit]
Description=TigerVNC server for %i
After=syslog.target network.target

[Service]
Type=forking
User=%i
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :%i -geometry 1920x1080 -depth 24 -localhost no
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
# Replace 'yourusername' with your actual username
sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1.service

# Check status
sudo systemctl status vncserver@1.service
```

### Secure VNC with SSH Tunnel

Best practice - don't expose VNC directly:
```bash
# On client machine, create SSH tunnel
ssh -L 5901:localhost:5901 -N -f username@server-ip

# Connect VNC client to localhost:5901
```

### Firewall Rules for VNC
```bash
# Only allow from local network (not recommended for internet)
sudo ufw allow from 192.168.1.0/24 to any port 5901 comment 'VNC Display :1'

# Better: Use SSH tunnel and don't open VNC port
```

## RDP (Remote Desktop Protocol)

### xRDP Server Setup

```bash
# Install xRDP
sudo apt install -y xrdp

# Add xrdp user to ssl-cert group
sudo adduser xrdp ssl-cert

# Configure xRDP for Ubuntu/GNOME
echo "gnome-session" > ~/.xsession

# Start and enable service
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Check status
sudo systemctl status xrdp
```

### Configure xRDP

Edit configuration:
```bash
sudo nano /etc/xrdp/xrdp.ini
```

Recommended settings:
```ini
[Globals]
; Security
security_layer=negotiate
crypt_level=high
ssl_protocols=TLSv1.2, TLSv1.3

; Performance
max_bpp=32
bitmap_compression=true

; Reduce latency
tcp_nodelay=true
tcp_keepalive=true
```

Restart after changes:
```bash
sudo systemctl restart xrdp
```

### Fix black screen or login issues

Create/edit:
```bash
sudo nano /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
```

Add:
```ini
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
```

### Firewall for RDP
```bash
# Allow RDP (port 3389)
sudo ufw allow 3389/tcp comment 'RDP'

# Or only from local network
sudo ufw allow from 192.168.1.0/24 to any port 3389 comment 'RDP LAN only'
```

### Connect from Client

**Windows:** Use built-in Remote Desktop Connection (mstsc.exe)
**Linux:** Use Remmina or rdesktop
```bash
sudo apt install -y remmina
```

**macOS:** Download Microsoft Remote Desktop from App Store

## NoMachine (High-Performance Alternative)

### Install NoMachine

```bash
# Download latest version
wget https://download.nomachine.com/download/8.11/Linux/nomachine_8.11.3_1_amd64.deb

# Install
sudo dpkg -i nomachine_8.11.3_1_amd64.deb
sudo apt install -f

# Service starts automatically
```

Benefits:
- Better performance than VNC
- Better than RDP for Linux
- Built-in security
- File transfer support
- Works well over slow connections

### Configure NoMachine

Configuration file: `/usr/NX/etc/server.cfg`

```bash
sudo nano /usr/NX/etc/server.cfg
```

Key settings:
```
# Change default port (optional)
NXPort 4000

# Enable encryption
EnableSSHSupport 1

# Limit connections
CommandScriptPolicy "default deny"
```

Restart service:
```bash
sudo /etc/NX/nxserver --restart
```

### Firewall for NoMachine
```bash
sudo ufw allow 4000/tcp comment 'NoMachine'
```

## Tailscale (Modern VPN Solution)

Easiest way to access your machine from anywhere:

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start and authenticate
sudo tailscale up

# Check status
tailscale status

# Get IP address
tailscale ip -4
```

Benefits:
- Zero configuration NAT traversal
- Automatic WireGuard VPN
- No port forwarding needed
- Works from anywhere
- Free for personal use

## Port Forwarding Setup

### Router Configuration

Typical steps (varies by router):

1. Access router admin panel (usually 192.168.1.1 or 192.168.0.1)
2. Navigate to Port Forwarding or NAT settings
3. Add port forwarding rules:

```
Service Name: SSH
External Port: 2222
Internal IP: 192.168.1.100 (your Geekom IP)
Internal Port: 2222
Protocol: TCP

Service Name: WireGuard
External Port: 51820
Internal IP: 192.168.1.100
Internal Port: 51820
Protocol: UDP
```

### Dynamic DNS (DDNS)

If you don't have a static IP:

```bash
# Use a DDNS service like:
# - DuckDNS (free)
# - No-IP (free tier available)
# - Cloudflare (free with domain)

# Example: DuckDNS setup
mkdir -p ~/scripts
nano ~/scripts/duckdns.sh
```

```bash
#!/bin/bash
echo url="https://www.duckdns.org/update?domains=YOUR_DOMAIN&token=YOUR_TOKEN&ip=" | curl -k -o ~/scripts/duckdns.log -K -
```

```bash
chmod +x ~/scripts/duckdns.sh

# Add to crontab
crontab -e
# Add: */5 * * * * ~/scripts/duckdns.sh
```

## Monitoring Remote Access

### Log all SSH connections
```bash
# View recent SSH connections
sudo journalctl -u ssh | tail -50

# Monitor in real-time
sudo tail -f /var/log/auth.log | grep sshd
```

### Monitor VNC/RDP connections
```bash
# VNC logs
cat ~/.vnc/*.log

# xRDP logs
sudo tail -f /var/log/xrdp.log
sudo tail -f /var/log/xrdp-sesman.log
```

### Who is connected
```bash
# Show logged in users
who

# More detailed
w

# Show last logins
last -a
```

## Web-Based Remote Access Tools

Web-based administration tools provide browser-based interfaces for managing your Geekom AX8 remotely. These tools are especially useful for quick system checks, monitoring, and basic administration without requiring dedicated client software.

### Cockpit - Modern Linux Server Manager

**Overview:**
Cockpit is a lightweight, web-based interface for Linux servers that provides real-time monitoring, container management, storage administration, and more through a clean, modern interface.

**Features:**
- Real-time performance graphs (CPU, memory, network, disk)
- Service management (start, stop, enable, disable systemd services)
- Storage management (disks, RAID, partitions, filesystems)
- Network configuration (interfaces, firewall, bonds)
- Container management (Podman integration)
- Terminal access in browser
- Software updates management
- User and group administration
- Log viewer with filtering
- Multi-server management from single interface

**Installation:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y cockpit

# Fedora (usually pre-installed)
sudo dnf install -y cockpit

# Start and enable service
sudo systemctl enable --now cockpit.socket

# Check status
sudo systemctl status cockpit.socket
```

**Optional Modules:**
```bash
# Container management (Podman)
sudo apt install -y cockpit-podman

# Virtual machine management
sudo apt install -y cockpit-machines

# File sharing (Samba)
sudo apt install -y cockpit-file-sharing

# Package management enhancements
sudo apt install -y cockpit-packagekit

# Storage management (advanced)
sudo apt install -y cockpit-storaged
```

**Configuration:**
```bash
# Configure Cockpit
sudo nano /etc/cockpit/cockpit.conf
```

```ini
[WebService]
# Allow connections from any host (default: local only)
Origins = https://your.domain.com wss://your.domain.com
AllowUnencrypted = false
LoginTitle = Geekom AX8 Management

[Session]
# Session timeout (in minutes)
IdleTimeout = 15
```

**Accessing Cockpit:**
- Default URL: `https://your-server-ip:9090`
- Login with your Linux user credentials
- Supports SSH key authentication
- HTTPS enabled by default with self-signed certificate

**Firewall Configuration:**
```bash
# Allow Cockpit (port 9090)
sudo ufw allow 9090/tcp comment 'Cockpit Web Interface'

# Or only from local network
sudo ufw allow from 192.168.1.0/24 to any port 9090 comment 'Cockpit LAN'
```

**Key Features Demonstration:**

1. **Real-time Monitoring:**
   - CPU usage graphs with per-core breakdown
   - Memory and swap utilization
   - Network throughput (RX/TX)
   - Disk I/O statistics
   - Historical data for trend analysis

2. **Service Management:**
   - View all systemd services
   - Start/stop/restart services with one click
   - Enable/disable services at boot
   - View service logs inline
   - Resource usage per service

3. **Terminal Access:**
   - Full terminal in browser
   - Multiple terminal tabs
   - Copy/paste support
   - No SSH client needed

4. **Container Management:**
   - Pull and run containers
   - View container logs
   - Manage container resources
   - Connect to container shells
   - Port mapping and volume management

**Screenshot Locations:**
- Dashboard: Shows system overview with graphs
- Services: List of all system services with status
- Storage: Disk management interface
- Networking: Network interface configuration
- Terminal: In-browser command line

**Best For:**
- Quick system monitoring
- Service management
- Container administration
- Users comfortable with modern web interfaces
- Multi-server environments

---

### Webmin - Comprehensive System Administration

**Overview:**
Webmin is a mature, feature-rich web-based system administration tool for Unix/Linux. It provides extensive configuration capabilities for nearly every aspect of system administration.

**Features:**
- Complete system configuration
- User and group management with detailed controls
- Package management (install, update, remove software)
- Scheduled tasks (cron jobs) with visual editor
- File manager with upload/download
- System backup and restore
- Apache, Nginx, MySQL/PostgreSQL management
- DNS, DHCP, and mail server configuration
- Firewall management (iptables, ufw)
- Disk quotas and RAID management
- SSL certificate management
- Custom module support

**Installation:**
```bash
# Download and install Webmin
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo bash setup-repos.sh

# Install Webmin
sudo apt install -y webmin

# Start Webmin (auto-starts on install)
sudo systemctl enable webmin
sudo systemctl start webmin

# Check status
sudo systemctl status webmin
```

**Alternative Installation (Direct Download):**
```bash
# Download latest version
wget https://www.webmin.com/download/deb/webmin-current.deb

# Install
sudo dpkg -i webmin-current.deb
sudo apt install -f  # Fix dependencies if needed
```

**Configuration:**
```bash
# Configure Webmin
sudo nano /etc/webmin/miniserv.conf
```

Key settings:
```
port=10000
listen=0.0.0.0
ssl=1
no_ssl2=1
no_ssl3=1
```

**Accessing Webmin:**
- Default URL: `https://your-server-ip:10000`
- Login: root or admin user
- HTTPS with self-signed certificate (accept exception in browser)

**Firewall Configuration:**
```bash
# Allow Webmin (port 10000)
sudo ufw allow 10000/tcp comment 'Webmin Interface'

# Restrict to local network (recommended)
sudo ufw allow from 192.168.1.0/24 to any port 10000 comment 'Webmin LAN only'
```

**Key Modules:**

1. **System Module:**
   - Bootup and shutdown
   - Scheduled cron jobs
   - System logs viewer
   - Running processes
   - Software package management

2. **Servers Module:**
   - Apache web server
   - MySQL/PostgreSQL databases
   - SSH server configuration
   - File server (Samba/NFS)
   - Email servers

3. **Networking Module:**
   - Network configuration
   - Firewall rules
   - Linux router and gateway
   - Network services

4. **Hardware Module:**
   - Disk and filesystem management
   - RAID configuration
   - Printer administration
   - System time configuration

**Security Hardening:**
```bash
# Change default port
sudo nano /etc/webmin/miniserv.conf
# Change: port=10000 to port=18888

# Restrict IP access
# Add in miniserv.conf:
allow=192.168.1.0/24

# Restart Webmin
sudo systemctl restart webmin
```

**Two-Factor Authentication:**
```bash
# Enable 2FA in Webmin:
# Webmin → Webmin Configuration → Two-Factor Authentication
# Choose Authenticator app or other method
```

**Best For:**
- Comprehensive system administration
- Users who prefer traditional server management
- Complex configurations (mail servers, DNS, etc.)
- Managing services not covered by Cockpit
- Advanced users who need fine-grained control

---

### Apache Guacamole - Clientless Remote Desktop Gateway

**Overview:**
Apache Guacamole is a clientless remote desktop gateway that supports VNC, RDP, SSH, and telnet through a web browser. No plugins or client software required.

**Features:**
- Access desktops via web browser only
- Supports VNC, RDP, SSH protocols
- Multi-protocol support (connect to Windows, Linux, any OS)
- Session recording and playback
- File transfer (browser to/from remote desktop)
- Copy/paste between browser and remote desktop
- Multi-user with role-based access control
- Connection sharing and monitoring
- Two-factor authentication support
- LDAP/Active Directory integration
- Clipboard integration

**Installation (Docker - Recommended):**
```bash
# Install Docker if not already installed
sudo apt update
sudo apt install -y docker.io docker-compose

# Create Guacamole directory
mkdir -p ~/guacamole
cd ~/guacamole

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  guacd:
    image: guacamole/guacd
    container_name: guacd
    restart: always
    volumes:
      - ./drive:/drive
      - ./record:/record

  postgres:
    image: postgres:15
    container_name: postgres_guacamole
    restart: always
    environment:
      POSTGRES_DB: guacamole_db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: your_secure_password
    volumes:
      - ./init:/docker-entrypoint-initdb.d
      - ./data:/var/lib/postgresql/data

  guacamole:
    image: guacamole/guacamole
    container_name: guacamole
    restart: always
    ports:
      - "8080:8080"
    environment:
      GUACD_HOSTNAME: guacd
      POSTGRES_HOSTNAME: postgres
      POSTGRES_DATABASE: guacamole_db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: your_secure_password
    depends_on:
      - guacd
      - postgres
EOF

# Initialize database
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > initdb.sql
mkdir -p init
mv initdb.sql init/

# Start Guacamole
docker-compose up -d

# Check status
docker-compose ps
```

**Accessing Guacamole:**
- URL: `http://your-server-ip:8080/guacamole`
- Default credentials: `guacadmin` / `guacadmin`
- **Important:** Change default password immediately!

**Initial Setup:**
1. Login with default credentials
2. Click on `guacadmin` (top right) → Settings
3. Click on `Preferences` tab
4. Change password
5. Configure connections under `Connections` tab

**Adding Connections:**

**SSH Connection:**
```
Connection Name: Geekom SSH
Protocol: SSH
Hostname: localhost
Port: 22
Username: your_username
Authentication: Password or SSH key
```

**VNC Connection:**
```
Connection Name: Geekom Desktop (VNC)
Protocol: VNC
Hostname: localhost
Port: 5901
Password: [your VNC password]
Color depth: True color (32-bit)
```

**RDP Connection:**
```
Connection Name: Geekom Desktop (RDP)
Protocol: RDP
Hostname: localhost
Port: 3389
Username: your_username
Password: [your password]
Security: Any
Ignore server certificate: true
```

**Reverse Proxy with Nginx (Recommended):**
```bash
# Install Nginx
sudo apt install -y nginx

# Create Guacamole config
sudo nano /etc/nginx/sites-available/guacamole
```

```nginx
server {
    listen 80;
    server_name guacamole.yourdomain.com;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name guacamole.yourdomain.com;
    
    # SSL certificates (use Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/guacamole.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/guacamole.yourdomain.com/privkey.pem;
    
    location /guacamole/ {
        proxy_pass http://localhost:8080/guacamole/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        proxy_cookie_path /guacamole/ /;
        access_log off;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/guacamole /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

**Firewall Configuration:**
```bash
# Allow Guacamole port
sudo ufw allow 8080/tcp comment 'Guacamole'

# If using Nginx reverse proxy
sudo ufw allow 'Nginx Full'
```

**Advanced Features:**

1. **Session Recording:**
   ```
   In connection settings:
   - Enable recording: checked
   - Recording path: /record
   - Recording name: ${GUAC_USERNAME}-${GUAC_DATE}-${GUAC_TIME}
   ```

2. **File Transfer:**
   - Automatic for RDP and SSH (SFTP)
   - Drag and drop files in browser
   - Download folder visible in session

3. **Two-Factor Authentication:**
   ```bash
   # Install TOTP extension
   docker exec guacamole wget https://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.5.3/binary/guacamole-auth-totp-1.5.3.jar
   # Copy to extensions folder and restart
   ```

**Best For:**
- Accessing multiple remote systems from browser
- Users without installed remote desktop clients
- Secure remote access gateway
- Organizations needing centralized access management
- Multi-protocol environment (Windows + Linux)
- Remote support scenarios

---

### Portainer - Docker and Container Management

**Overview:**
Portainer is a lightweight management UI for Docker, making container management accessible through a web browser. Perfect for managing containerized applications on your Geekom AX8.

**Features:**
- Visual container management
- Easy image pulling and deployment
- Container logs and stats in real-time
- Docker Compose support
- Volume and network management
- User access control
- Template library for popular apps
- Stack deployment (multi-container apps)
- Registry management
- Webhook support for CI/CD
- Resource constraints configuration

**Installation:**
```bash
# Install Docker if not already installed
sudo apt update
sudo apt install -y docker.io

# Create Portainer volume
docker volume create portainer_data

# Run Portainer container
docker run -d \
  -p 9000:9000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

# Check if running
docker ps | grep portainer
```

**Accessing Portainer:**
- HTTP: `http://your-server-ip:9000`
- HTTPS: `https://your-server-ip:9443` (recommended)

**Initial Setup:**
1. Navigate to Portainer URL
2. Create admin username and password (first time only)
3. Select "Docker" as environment type
4. Click "Connect" to manage local Docker

**Firewall Configuration:**
```bash
# Allow Portainer
sudo ufw allow 9443/tcp comment 'Portainer HTTPS'

# Or restrict to local network
sudo ufw allow from 192.168.1.0/24 to any port 9443 comment 'Portainer LAN'
```

**Key Features:**

1. **Dashboard:**
   - Total containers, running, stopped
   - Images count
   - Volumes and networks
   - Quick actions

2. **Container Management:**
   - Start/stop/restart containers
   - View logs in real-time
   - Execute commands in container (shell access)
   - Inspect container details
   - View resource usage (CPU, memory)
   - Attach to container console

3. **Image Management:**
   - Pull images from Docker Hub or private registries
   - Remove unused images
   - Build images from Dockerfile
   - Tag and push images

4. **Quick Deploy from Templates:**
   ```
   Available templates:
   - Nginx
   - MySQL, PostgreSQL, MongoDB
   - WordPress
   - GitLab
   - Jenkins
   - Nextcloud
   - And many more...
   ```

**Example: Deploy a Container:**
```
1. Containers → Add Container
2. Name: nginx-test
3. Image: nginx:latest
4. Port mapping: 8080:80
5. Deploy
```

**Docker Compose via Portainer:**
```yaml
# In Portainer: Stacks → Add Stack
# Name: myapp
# Web editor:

version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
  
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secretpassword
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

**User Management:**
```
Settings → Users → Add User
- Username: developer
- Password: [secure password]
- Role: User (limited access) or Admin
- Assign to teams or endpoints
```

**Best For:**
- Docker container management
- Users new to Docker
- Quick container deployment
- Monitoring containerized applications
- Managing multiple Docker hosts
- Development and testing environments

---

### Comparison: Web-Based Tools

| Tool | Best For | Complexity | Resource Usage | Key Strength |
|------|----------|------------|----------------|--------------|
| **Cockpit** | System monitoring & services | Low | Very Low | Modern, lightweight, real-time monitoring |
| **Webmin** | Complete system admin | Medium | Low | Comprehensive configuration options |
| **Guacamole** | Remote desktop gateway | Medium-High | Medium | Browser-based RDP/VNC/SSH access |
| **Portainer** | Container management | Low | Very Low | Easy Docker management |

### Recommended Setup

**For General Use:**
```bash
# Install Cockpit for system monitoring
sudo apt install -y cockpit cockpit-podman

# Install Portainer for containers
docker run -d -p 9443:9443 --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

**For Advanced Administration:**
```bash
# Add Webmin for detailed configuration
sudo bash setup-repos.sh
sudo apt install -y webmin
```

**For Remote Desktop Access:**
```bash
# Deploy Guacamole with Docker
cd ~/guacamole
docker-compose up -d
```

### Security Best Practices for Web Tools

1. **Use HTTPS Only**
   ```bash
   # Generate self-signed certificate (for testing)
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /etc/ssl/private/selfsigned.key \
     -out /etc/ssl/certs/selfsigned.crt
   ```

2. **Restrict Access by IP**
   ```bash
   # Firewall rules for local network only
   sudo ufw allow from 192.168.1.0/24 to any port 9090 comment 'Cockpit'
   sudo ufw allow from 192.168.1.0/24 to any port 10000 comment 'Webmin'
   sudo ufw allow from 192.168.1.0/24 to any port 9443 comment 'Portainer'
   ```

3. **Use Reverse Proxy**
   - Centralize access through Nginx/Apache
   - Single SSL certificate
   - Better logging and monitoring
   - Rate limiting

4. **Enable Authentication**
   - Strong passwords (minimum 16 characters)
   - Two-factor authentication where available
   - SSH key authentication for Cockpit
   - LDAP integration for larger setups

5. **Keep Updated**
   ```bash
   # Regular updates
   sudo apt update && sudo apt upgrade -y
   
   # Update Docker images
   docker pull portainer/portainer-ce:latest
   docker pull guacamole/guacamole:latest
   ```

6. **Monitor Access**
   ```bash
   # Check authentication logs
   sudo journalctl -u cockpit.socket -f
   sudo tail -f /var/webmin/miniserv.log
   docker logs -f portainer
   ```

### Quick Access URLs Summary

After installation, bookmark these:

```
System Monitoring: https://geekom-ax8:9090 (Cockpit)
System Admin: https://geekom-ax8:10000 (Webmin)
Remote Desktop: http://geekom-ax8:8080/guacamole (Guacamole)
Container Management: https://geekom-ax8:9443 (Portainer)
```

**Note:** Replace `geekom-ax8` with your actual hostname or IP address.

## Access Methods Comparison

| Method | Performance | Security | Ease of Use | Best For |
|--------|------------|----------|-------------|----------|
| SSH | N/A | Excellent | Good | CLI, tunneling |
| VNC | Good | Fair* | Good | Full desktop, cross-platform |
| RDP | Very Good | Good | Excellent | Windows clients |
| NoMachine | Excellent | Good | Excellent | Best performance, Linux |
| Tailscale | Excellent | Excellent | Excellent | Easy secure access |
| Cockpit | N/A | Good | Excellent | System monitoring, web UI |
| Webmin | N/A | Good | Good | Complete system admin |
| Guacamole | Very Good | Good | Excellent | Browser-based remote desktop |
| Portainer | N/A | Good | Excellent | Docker/container management |

*VNC security is fair only when tunneled through SSH

## Troubleshooting

### Can't connect remotely

1. Check if service is running locally
2. Check firewall allows the port
3. Check router port forwarding
4. Check ISP doesn't block the port
5. Verify dynamic DNS is updating
6. Check public IP hasn't changed

### Slow performance

1. Reduce screen resolution
2. Lower color depth
3. Disable desktop effects
4. Use compression (SSH -C, VNC compression)
5. Check network bandwidth
6. Consider NoMachine for better performance

### Black screen in VNC/RDP

1. Check xstartup file
2. Try different desktop environment
3. Check display manager conflicts
4. Review service logs
5. Ensure user has active session
