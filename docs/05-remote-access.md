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

## Access Methods Comparison

| Method | Performance | Security | Ease of Use | Best For |
|--------|------------|----------|-------------|----------|
| SSH | N/A | Excellent | Good | CLI, tunneling |
| VNC | Good | Fair* | Good | Full desktop, cross-platform |
| RDP | Very Good | Good | Excellent | Windows clients |
| NoMachine | Excellent | Good | Excellent | Best performance, Linux |
| Tailscale | Excellent | Excellent | Excellent | Easy secure access |

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
