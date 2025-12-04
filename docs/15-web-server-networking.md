# Web Server, Networking, and Public Services Guide

## Overview

This guide covers setting up public-facing services on your Geekom AX8, including web server selection (Nginx vs Apache), UI management tools, dynamic DNS configuration, Docker port management strategies, and VPN options for secure access.

**Topics Covered:**
- Nginx vs Apache comparison and recommendations
- Web server UI management tools
- Dynamic DNS setup for residential ISP (Comcast/Surfboard)
- Docker service port management and reverse proxy configuration
- VPN options and cost comparison
- Security best practices for public services

---

## Web Server: Nginx vs Apache

### Quick Recommendation

**For home server with multiple Docker services: Use Nginx** (specifically Nginx Proxy Manager for ease of use)

### Detailed Comparison

| Feature | Nginx | Apache |
|---------|-------|--------|
| **Performance** | Excellent for static content and reverse proxy | Good, more resource intensive |
| **Memory Usage** | Very Low (~2-10MB per worker) | Higher (~20-30MB per process) |
| **Concurrent Connections** | Excellent (event-driven, async) | Good (process/thread-based) |
| **Configuration** | Simple, declarative syntax | More complex, .htaccess support |
| **Reverse Proxy** | Excellent, designed for it | Capable but heavier |
| **Learning Curve** | Moderate | Moderate |
| **Docker Integration** | Excellent | Good |
| **Dynamic Content** | Requires FastCGI/proxy | Built-in via modules |
| **Market Share** | ~34% of active sites | ~30% of active sites |
| **Best For** | Reverse proxy, load balancing, high concurrency | Traditional web hosting, .htaccess needs |

### Why Nginx for Your Use Case?

Given your plan to serve multiple Docker services to the public:

1. **Better Resource Efficiency**: Nginx uses significantly less memory, important when running many services
2. **Reverse Proxy Excellence**: Designed specifically for proxying requests to backend services (your Docker containers)
3. **Easy SSL/TLS Management**: Simpler to configure SSL for multiple domains
4. **Better for Microservices**: Perfect for routing to different Docker containers based on domain/path
5. **Lightweight**: Less overhead means more resources for your actual services

### When to Choose Apache Instead?

- You need .htaccess support for dynamic configuration
- Running traditional PHP applications that expect Apache
- Need specific Apache modules not available in Nginx
- Team is already familiar with Apache

---

## UI Management Tools for Nginx

### Nginx Proxy Manager (NPM) - Highly Recommended

**What is it?**
A Docker-based web interface for managing Nginx reverse proxy configurations with automatic SSL certificates from Let's Encrypt.

**Why use it?**
- No command-line configuration needed
- Automatic SSL certificate management
- Beautiful, intuitive web UI
- Perfect for managing multiple Docker services
- Built-in access control
- Free and open source

#### Installation with Docker

```bash
# Create directory for Nginx Proxy Manager
mkdir -p ~/nginx-proxy-manager
cd ~/nginx-proxy-manager

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  nginx-proxy-manager:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      # HTTP
      - '80:80'
      # HTTPS
      - '443:443'
      # Admin Web Interface
      - '81:81'
    environment:
      DB_SQLITE_FILE: "/data/database.sqlite"
      # Uncomment for MySQL instead of SQLite
      # DB_MYSQL_HOST: "npm-db"
      # DB_MYSQL_PORT: 3306
      # DB_MYSQL_USER: "npm"
      # DB_MYSQL_PASSWORD: "change_this_password"
      # DB_MYSQL_NAME: "npm"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt

  # Optional: MySQL database (recommended for production)
  # npm-db:
  #   image: 'mariadb:latest'
  #   restart: unless-stopped
  #   environment:
  #     MYSQL_ROOT_PASSWORD: 'npm_root_password'
  #     MYSQL_DATABASE: 'npm'
  #     MYSQL_USER: 'npm'
  #     MYSQL_PASSWORD: 'change_this_password'
  #   volumes:
  #     - ./mysql:/var/lib/mysql
EOF

# Start Nginx Proxy Manager
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs -f
```

#### Initial Setup

1. **Access the Admin Interface:**
   - URL: `http://your-ax8-ip:81`
   - Default credentials:
     - Email: `admin@example.com`
     - Password: `changeme`
   - **IMPORTANT**: Change these immediately after first login!

2. **Initial Configuration:**
   - Change admin email and password
   - Configure your email for Let's Encrypt notifications
   - Verify the service is accessible

#### Adding a Proxy Host

**Example: Route a domain to a Docker container**

```
Proxy Hosts → Add Proxy Host

Details Tab:
- Domain Names: myapp.yourdomain.com
- Scheme: http
- Forward Hostname/IP: name-of-docker-container (or IP)
- Forward Port: 8080 (container's internal port)
- Cache Assets: ✓ (optional)
- Block Common Exploits: ✓
- Websockets Support: ✓ (if your app uses websockets)

SSL Tab:
- SSL Certificate: Request a new SSL Certificate
- Force SSL: ✓
- HTTP/2 Support: ✓
- HSTS Enabled: ✓
- Email for Let's Encrypt: your-email@example.com
- I Agree to Let's Encrypt TOS: ✓
```

Click Save - NPM will automatically obtain and configure SSL certificate!

#### Example: Multiple Services

Assuming you have these Docker services running:
- Nextcloud on port 8081
- Jellyfin on port 8096
- Home Assistant on port 8123

```
Proxy Hosts Configuration:

1. cloud.yourdomain.com → nextcloud:8081
2. media.yourdomain.com → jellyfin:8096
3. home.yourdomain.com → home-assistant:8123
```

Nginx Proxy Manager handles all SSL, routing, and configuration automatically!

#### Benefits of Nginx Proxy Manager

✅ No manual Nginx configuration files
✅ Automatic SSL certificate renewal
✅ Easy to manage multiple domains/subdomains
✅ Access control and authentication
✅ Custom SSL certificates supported
✅ Stream (TCP/UDP) support
✅ Built-in monitoring and logs
✅ Very low resource usage

### Alternative: Traefik

**What is it?**
A modern reverse proxy designed specifically for Docker and microservices.

**Features:**
- Automatic service discovery
- Dynamic configuration from Docker labels
- Automatic SSL with Let's Encrypt
- Load balancing
- WebSocket support
- More complex but more powerful

**When to use Traefik instead:**
- Running Kubernetes
- Need advanced routing rules
- Want fully automated service discovery
- Large number of services (50+)

#### Quick Traefik Setup

```bash
mkdir -p ~/traefik
cd ~/traefik

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    ports:
      - 80:80
      - 443:443
      - 8080:8080  # Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik.yml:/traefik.yml:ro
      - ./acme.json:/acme.json
      - ./config:/config
    environment:
      - CF_API_EMAIL=your-email@example.com  # If using Cloudflare DNS
      - CF_API_KEY=your-cloudflare-api-key
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(`traefik.yourdomain.com`)"
      - "traefik.http.routers.traefik.entrypoints=https"
      - "traefik.http.routers.traefik.tls.certresolver=cloudflare"
      - "traefik.http.routers.traefik.service=api@internal"
EOF

# Create traefik.yml
cat > traefik.yml << 'EOF'
api:
  dashboard: true

entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: https
          scheme: https
  https:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    directory: /config
    watch: true

certificatesResolvers:
  cloudflare:
    acme:
      email: your-email@example.com
      storage: acme.json
      dnsChallenge:
        provider: cloudflare
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
EOF

# Set correct permissions
chmod 600 acme.json

# Start Traefik
docker-compose up -d
```

**Configure services with labels:**

```yaml
# Example: Adding Nextcloud with Traefik
version: '3'

services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.nextcloud.rule=Host(`cloud.yourdomain.com`)"
      - "traefik.http.routers.nextcloud.entrypoints=https"
      - "traefik.http.routers.nextcloud.tls.certresolver=cloudflare"
      - "traefik.http.services.nextcloud.loadbalancer.server.port=80"
```

### Other UI Tools

#### Portainer (Already discussed in Remote Access guide)
- Manages Docker containers
- Not specifically for Nginx/web server
- Good for overall container management

#### CaddyServer
- Alternative to Nginx
- Automatic HTTPS by default
- Very simple configuration
- Good choice if starting fresh

---

## Dynamic DNS Setup

### Why You Need Dynamic DNS

**The Problem:**
- Residential ISPs (like Comcast) typically assign dynamic IP addresses
- Your public IP address can change periodically (power outage, ISP maintenance)
- You need a consistent way to access your home server

**The Solution:**
- Dynamic DNS (DDNS) automatically updates DNS records when your IP changes
- Access your server via domain name (e.g., `myserver.duckdns.org`) instead of IP
- Works seamlessly with your Surfboard cable modem

### Does Your IP Actually Change?

First, check your current setup:

```bash
# Check your current public IP
curl -4 ifconfig.me

# Wait a day or two, check again
# Or check after router restart
sudo reboot

# After reboot, check again
curl -4 ifconfig.me

# If the IP is different, you need DDNS
```

### Recommended DDNS Services

#### 1. DuckDNS (Best Free Option)

**Features:**
- Completely free
- No account required (uses token)
- Simple API
- 5-minute update interval recommended
- Supports multiple domains
- IPv4 and IPv6 support

**Setup:**

1. **Get a DuckDNS Domain:**
   - Visit https://www.duckdns.org
   - Sign in with Google, GitHub, or other provider
   - Choose a subdomain: `yourname.duckdns.org`
   - Copy your token (long string of characters)

2. **Install Update Script:**

```bash
# Create scripts directory
mkdir -p ~/scripts
cd ~/scripts

# Create DuckDNS update script
cat > duckdns.sh << 'EOF'
#!/bin/bash
# DuckDNS Update Script
# Replace YOUR_DOMAIN and YOUR_TOKEN with your actual values

DOMAIN="yourname"  # Just the subdomain part, not .duckdns.org
TOKEN="your-token-here-from-duckdns-website"

# Update DuckDNS
echo url="https://www.duckdns.org/update?domains=${DOMAIN}&token=${TOKEN}&ip=" | curl -k -o ~/scripts/duckdns.log -K -

# Log the update
date >> ~/scripts/duckdns.log
cat ~/scripts/duckdns.log | tail -2
EOF

# Make executable
chmod +x duckdns.sh

# Edit the script to add your domain and token
nano duckdns.sh

# Test the script
./duckdns.sh
# Should output "OK" if successful
```

3. **Automate with Cron:**

```bash
# Open crontab
crontab -e

# Add this line to update every 5 minutes
*/5 * * * * ~/scripts/duckdns.sh >/dev/null 2>&1

# Or be more verbose and log to file
*/5 * * * * ~/scripts/duckdns.sh >> ~/scripts/duckdns.log 2>&1
```

4. **Verify It Works:**

```bash
# Check the log
cat ~/scripts/duckdns.log

# Test resolving your domain
nslookup yourname.duckdns.org

# Should show your current public IP
```

#### 2. No-IP (Free Tier Available)

**Features:**
- Free tier: 3 hostnames
- Requires monthly confirmation (login once per month)
- More professional if you later upgrade
- Dynamic DNS client available

**Setup:**

1. Create account at https://www.noip.com
2. Add a hostname (e.g., `yourserver.ddns.net`)
3. Install the No-IP DUC (Dynamic Update Client):

```bash
# Download and install No-IP DUC
cd /usr/local/src/
sudo wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
sudo tar xf noip-duc-linux.tar.gz
cd noip-2.1.9-1/
sudo make install

# Configure (enter your No-IP credentials when prompted)
sudo noip2 -C

# Start the client
sudo noip2

# Create systemd service
sudo nano /etc/systemd/system/noip2.service
```

```ini
[Unit]
Description=No-IP Dynamic DNS Update Client
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/noip2

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable noip2
sudo systemctl start noip2
```

#### 3. Cloudflare (Best If You Own a Domain)

**Features:**
- Free if you have a domain
- Fastest DNS resolution globally
- DDoS protection included
- Professional DNS management
- API for automated updates

**Setup:**

1. **Transfer/Add Your Domain to Cloudflare:**
   - Sign up at https://cloudflare.com
   - Add your domain (e.g., `yourdomain.com`)
   - Update nameservers at your registrar
   - Domain costs ~$10-15/year at most registrars

2. **Create API Token:**
   - My Profile → API Tokens → Create Token
   - Template: "Edit zone DNS"
   - Zone Resources: Include → Specific zone → yourdomain.com
   - Copy the token

3. **Install Cloudflare DDNS Script:**

```bash
# Install cloudflare-ddns script
cd ~/scripts

cat > cloudflare-ddns.sh << 'EOF'
#!/bin/bash
# Cloudflare DDNS Update Script

# Configuration
API_TOKEN="your_cloudflare_api_token"
ZONE_ID="your_zone_id"
RECORD_NAME="home.yourdomain.com"  # The A record to update
RECORD_ID="your_record_id"

# Get current public IP
CURRENT_IP=$(curl -s -4 ifconfig.me)

# Update Cloudflare
RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"A\",\"name\":\"${RECORD_NAME}\",\"content\":\"${CURRENT_IP}\",\"ttl\":120,\"proxied\":false}")

echo "$(date): Updated ${RECORD_NAME} to ${CURRENT_IP}"
echo "$RESPONSE" | jq .
EOF

chmod +x cloudflare-ddns.sh
nano cloudflare-ddns.sh  # Add your values
```

4. **Get Zone ID and Record ID:**

```bash
# Get Zone ID (using your email and Global API Key)
curl -X GET "https://api.cloudflare.com/client/v4/zones?name=yourdomain.com" \
  -H "Authorization: Bearer your_api_token" \
  -H "Content-Type: application/json" | jq

# Get Record ID (use your Zone ID)
curl -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records?name=home.yourdomain.com" \
  -H "Authorization: Bearer your_api_token" \
  -H "Content-Type: application/json" | jq
```

5. **Automate:**

```bash
# Add to crontab
crontab -e

# Update every 5 minutes
*/5 * * * * ~/scripts/cloudflare-ddns.sh >> ~/scripts/cloudflare-ddns.log 2>&1
```

### DDNS Comparison

| Service | Cost | Domains | Update Method | Best For |
|---------|------|---------|---------------|----------|
| **DuckDNS** | Free | Unlimited subdomains | Script/API | Quick setup, testing |
| **No-IP** | Free (3 hosts) | 3 hostnames | Client/API | Simple needs |
| **Cloudflare** | Free (need domain) | Unlimited | API | Professional setup, own domain |
| **Google Domains** | $12/year (domain) | Unlimited | Built-in DDNS | Integrated solution |

### Comcast/Surfboard Gateway Considerations

**Built-in DDNS:**
Some Surfboard modems have built-in DDNS support:
- Log into your modem admin (usually `192.168.100.1`)
- Check for DDNS settings
- If available, configure directly in modem

**Port Forwarding:**
You'll need to configure port forwarding in your Surfboard gateway:
- Access admin at `192.168.100.1` or `192.168.0.1`
- Find Port Forwarding / NAT section
- Add rules (covered in next section)

---

## Docker Service Port Management

### The Challenge

When running multiple Docker services, each needs:
- A unique port
- Accessible from the internet (for public services)
- SSL certificate for HTTPS
- Security and isolation

### Solution Strategies

#### Strategy 1: Reverse Proxy (Recommended)

**Use Nginx Proxy Manager to route everything through ports 80/443**

**Architecture:**
```
Internet → Router Port Forwarding (80, 443)
         ↓
    Nginx Proxy Manager (ports 80, 443)
         ↓
    Routes to Docker containers based on domain/subdomain
         ↓
    service1:8080, service2:8096, service3:8123, etc.
```

**Benefits:**
- Only expose ports 80 and 443 to internet
- All services get automatic SSL
- Easy to manage
- Professional setup
- Better security (one point of entry)

**Setup Example:**

```yaml
# docker-compose.yml for your services
version: '3'

networks:
  proxy:
    external: true  # Shared network with Nginx Proxy Manager

services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "80"  # Expose internally, not to host
    volumes:
      - ./nextcloud:/var/www/html

  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "8096"
    volumes:
      - ./jellyfin/config:/config
      - ./jellyfin/media:/media

  homeassistant:
    image: homeassistant/home-assistant:latest
    container_name: homeassistant
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "8123"
    volumes:
      - ./homeassistant:/config
```

Create the shared network:
```bash
docker network create proxy
```

In Nginx Proxy Manager:
- `cloud.yourdomain.com` → `nextcloud:80`
- `media.yourdomain.com` → `jellyfin:8096`
- `home.yourdomain.com` → `homeassistant:8123`

**Port Forwarding on Router:**
- Only forward ports 80 and 443 to your server IP
- All services accessible via subdomains

#### Strategy 2: Individual Port Forwarding (Not Recommended)

**Architecture:**
```
Internet → Router Port Forwarding (different port per service)
         ↓
    service1:8080, service2:8096, service3:8123, etc.
```

**Problems:**
- Must remember many ports
- Must forward each port individually
- SSL certificates complex
- More security risks
- Unprofessional URLs (`http://yourdomain.com:8096`)

**Only use if:**
- Running just 1-2 services
- Learning/testing
- Don't care about SSL
- Don't have domain name

#### Strategy 3: VPN Access Only (Most Secure)

**Don't expose anything to internet. Use VPN to access internal network.**

**Architecture:**
```
Internet → VPN Server (WireGuard port 51820)
         ↓
    VPN Tunnel
         ↓
    Access all services on internal IPs
```

**Benefits:**
- Maximum security
- Simple port forwarding (just VPN port)
- Access everything as if you're home
- No SSL needed (trusted network)

**Downsides:**
- Must connect to VPN to access services
- Can't share access easily with friends/family
- Requires VPN client on all devices

**Best for:**
- Personal use only
- Maximum security needs
- Already using VPN

### Recommended Setup for Public Services

**Hybrid Approach:**

1. **Public Services:** Use reverse proxy (Nginx Proxy Manager)
   - Media sharing (Jellyfin/Plex)
   - Cloud storage you want accessible everywhere
   - Services for friends/family

2. **Admin/Private Services:** VPN access only
   - Administrative interfaces
   - Sensitive data
   - Development environments
   - Database admin tools

3. **Port Forwarding Configuration:**
   - Port 80 (HTTP) → Nginx Proxy Manager
   - Port 443 (HTTPS) → Nginx Proxy Manager
   - Port 51820 (UDP) → WireGuard VPN
   - Optional: Port 22 → SSH (change to non-standard port)

### Docker Compose Best Practices

```yaml
# Complete example with networking
version: '3'

networks:
  proxy:
    external: true
  internal:
    driver: bridge

services:
  # Frontend services (public via reverse proxy)
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    networks:
      - proxy
      - internal
    environment:
      - POSTGRES_HOST=nextcloud-db
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=secure_password
    volumes:
      - ./nextcloud:/var/www/html
    depends_on:
      - nextcloud-db

  # Backend service (internal only)
  nextcloud-db:
    image: postgres:15
    container_name: nextcloud-db
    restart: unless-stopped
    networks:
      - internal  # Not exposed to proxy network
    environment:
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      - POSTGRES_PASSWORD=secure_password
    volumes:
      - ./nextcloud-db:/var/lib/postgresql/data
```

---

## VPN Options and Comparison

### Why Use a VPN for Home Server?

**Benefits:**
1. **Secure Remote Access:** Encrypted connection to your home network
2. **No Port Forwarding Hassle:** Only VPN port needs to be open
3. **Access Internal Services:** Reach services not exposed publicly
4. **Privacy:** ISP can't see your traffic content
5. **Bypass Geographic Restrictions:** Appear to be at home when traveling
6. **Multiple Devices:** Secure all your devices when away from home

**VPN vs Reverse Proxy:**
- **VPN:** Access your internal network (like being at home)
- **Reverse Proxy:** Expose specific services to internet (public access)
- **Best:** Use both - VPN for admin, reverse proxy for public services

### VPN Solutions Comparison

#### 1. Tailscale (Easiest - Recommended)

**What is it?**
Zero-configuration mesh VPN using WireGuard. Free for personal use (up to 100 devices).

**Features:**
- Zero configuration needed
- No port forwarding required (NAT traversal)
- Mesh network (all devices can connect to each other)
- Cross-platform (Linux, Windows, Mac, iOS, Android)
- Centralized management
- Access control lists
- MagicDNS (automatic hostname resolution)
- Free tier: 1 user, 100 devices

**Cost:**
- Personal: **FREE** (up to 100 devices)
- Personal Pro: $48/year (additional features)
- Team: $5/user/month

**Setup:**

```bash
# Install Tailscale on your AX8
curl -fsSL https://tailscale.com/install.sh | sh

# Authenticate and connect
sudo tailscale up

# Check status
tailscale status

# Get your Tailscale IP
tailscale ip -4
# Example output: 100.101.102.103
```

**On client devices:**
1. Install Tailscale app
2. Login with same account
3. Automatically connected!

**Accessing Services:**
```bash
# Access your server services
http://100.101.102.103:9090  # Cockpit
http://100.101.102.103:81    # Nginx Proxy Manager admin
ssh user@100.101.102.103
```

**Pros:**
- Easiest to set up (5 minutes)
- No router configuration needed
- Works from anywhere (coffee shop, hotel, etc.)
- Free for personal use
- Excellent documentation
- Active development

**Cons:**
- Requires third-party service (Tailscale)
- Free tier limited to 100 devices (sufficient for home use)
- Depends on Tailscale infrastructure

**Best For:** 
- Most home users
- Anyone wanting simplicity
- Multi-device access
- People behind CG-NAT or restrictive networks

#### 2. WireGuard (Most Control)

**What is it?**
Modern, lightweight VPN protocol. Fast, secure, and minimal overhead.

**Features:**
- Extremely fast (faster than OpenVPN)
- Modern cryptography
- Minimal attack surface
- Built into Linux kernel
- ~4,000 lines of code (vs OpenVPN's 100,000+)
- Low resource usage

**Cost:**
- **FREE** (open source)
- Only cost: your time to configure

**Setup:**

```bash
# Install WireGuard
sudo apt install -y wireguard wireguard-tools

# Generate server keys
wg genkey | sudo tee /etc/wireguard/server_private.key | wg pubkey | sudo tee /etc/wireguard/server_public.key

# Secure private key
sudo chmod 600 /etc/wireguard/server_private.key

# Create server configuration
sudo nano /etc/wireguard/wg0.conf
```

```ini
[Interface]
# Server configuration
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <server_private_key_here>

# Enable IP forwarding
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o enp2s0 -j MASQUERADE

# Client 1 (your laptop)
[Peer]
PublicKey = <client1_public_key>
AllowedIPs = 10.0.0.2/32

# Client 2 (your phone)
[Peer]
PublicKey = <client2_public_key>
AllowedIPs = 10.0.0.3/32
```

**Enable IP forwarding:**
```bash
# Enable IP forwarding
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

**Start WireGuard:**
```bash
# Start WireGuard
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0

# Check status
sudo wg show
```

**Firewall rules:**
```bash
# Allow WireGuard
sudo ufw allow 51820/udp comment 'WireGuard VPN'

# Allow forwarding from VPN subnet
sudo ufw route allow in on wg0 out on enp2s0
```

**Router Port Forwarding:**
- Forward UDP port 51820 to your server IP

**Client Setup (example for Linux):**
```bash
# On client device
wg genkey | tee client_private.key | wg pubkey > client_public.key

# Create client config
nano ~/wg0-client.conf
```

```ini
[Interface]
Address = 10.0.0.2/24
PrivateKey = <client_private_key>
DNS = 1.1.1.1

[Peer]
PublicKey = <server_public_key>
Endpoint = your-ddns-domain.duckdns.org:51820
AllowedIPs = 0.0.0.0/0  # Route all traffic through VPN
# Or use 10.0.0.0/24 to only route VPN subnet
PersistentKeepalive = 25
```

**Connect:**
```bash
sudo wg-quick up ./wg0-client.conf
```

**Pros:**
- Complete control
- Fast and lightweight
- No third-party dependencies
- Free forever
- Built into modern Linux kernels
- Excellent security

**Cons:**
- Manual configuration required
- Must manage keys manually
- Need to configure each client
- Requires port forwarding
- Steeper learning curve

**Best For:**
- Power users wanting full control
- Those who don't trust third-party VPN services
- Advanced networking setups
- Maximum privacy

#### 3. ZeroTier (Alternative to Tailscale)

**What is it?**
Another mesh VPN solution, similar to Tailscale.

**Features:**
- Mesh networking
- No port forwarding needed
- Cross-platform
- Free tier: 1 network, 25 devices

**Cost:**
- Free: 1 network, 25 devices
- Professional: $5/month (per network, unlimited devices)

**Setup:**
```bash
# Install ZeroTier
curl -s https://install.zerotier.com | sudo bash

# Join network (get network ID from https://my.zerotier.com)
sudo zerotier-cli join <network-id>

# Authorize device on ZeroTier central
# Visit my.zerotier.com → your network → authorize device
```

**Pros:**
- Similar to Tailscale
- Slightly cheaper for teams
- Good for IoT devices

**Cons:**
- Less polished than Tailscale
- Smaller community
- More complex management

**Best For:**
- Alternative to Tailscale
- IoT device integration
- Larger networks (25+ devices on free tier)

#### 4. OpenVPN (Traditional)

**What is it?**
Mature, widely-supported VPN protocol. Been around since 2001.

**Features:**
- Very mature and stable
- Widely supported
- Highly configurable
- Can run on TCP or UDP
- Compatible with older systems

**Cost:**
- **FREE** (open source)
- OpenVPN Access Server: Free for 2 concurrent connections, paid beyond that

**Setup (using PiVPN script for easier installation):**
```bash
# Install using PiVPN (works on any Debian/Ubuntu, not just Pi)
curl -L https://install.pivpn.io | bash

# Follow interactive installer
# Choose OpenVPN
# Configure settings
# Create user profiles
```

**Pros:**
- Very mature and tested
- Works on almost any device
- Can bypass more restrictive firewalls (TCP mode)
- Extensive documentation

**Cons:**
- Slower than WireGuard
- More complex configuration
- Larger resource footprint
- More code = larger attack surface

**Best For:**
- Compatibility with older devices
- Corporate environments requiring proven solution
- Situations where you need TCP mode

#### 5. Commercial VPN Services (Different Use Case)

**Services like:**
- NordVPN: $3.49/month (2-year plan)
- ExpressVPN: $8.32/month (annual plan)
- Mullvad: €5/month
- ProtonVPN: Free tier available, paid from $4.99/month

**Note:** These are for privacy when browsing, NOT for accessing your home server!

**Use these when:**
- You want to hide your browsing from ISP
- Access region-locked content
- Privacy on public WiFi
- Bypass censorship

**Don't use these for:**
- Accessing your home server (wrong direction!)
- Internal network access
- Self-hosted services

### VPN Cost Summary

| Solution | Setup Cost | Monthly Cost | Annual Cost | Best For |
|----------|-----------|--------------|-------------|----------|
| **Tailscale** | Free | Free (personal) | Free | Easiest, recommended |
| **WireGuard** | Free | Free | Free | DIY, full control |
| **ZeroTier** | Free | Free (25 devices) | Free | Tailscale alternative |
| **OpenVPN** | Free | Free | Free | Compatibility needs |
| **Commercial VPNs** | $0 | $3-10 | $36-120 | Privacy browsing (different use) |

### Recommendation for Your Setup

**Best Overall: Tailscale**
- Free for personal use
- Works immediately without router configuration
- Perfect for accessing your Comcast home network
- Scales well with multiple Docker services
- No ongoing costs

**If you want full control: WireGuard**
- Free forever
- Great performance
- Requires port forwarding on Surfboard gateway
- More setup work but worth it for privacy-conscious users

**Hybrid Approach (Recommended):**
1. **Public services → Nginx Proxy Manager** (ports 80, 443)
   - Services you want to share publicly
   - Automatic SSL certificates
   - Professional URLs

2. **Admin access → Tailscale VPN** (free)
   - Administrative interfaces
   - Private services
   - Management tools
   - No port forwarding needed

3. **Port Forwarding:**
   - Ports 80, 443 → Nginx Proxy Manager
   - No VPN port needed (Tailscale handles it)

---

## Complete Setup Guide

### Scenario: Multiple Public Services + Secure Admin Access

**Services to Host:**
- Nextcloud (personal cloud)
- Jellyfin (media server)
- WordPress blog
- Home Assistant (home automation)

**Requirements:**
- Public access to above services
- Secure admin access
- Automatic SSL
- Easy to manage

### Step-by-Step Implementation

#### Step 1: Dynamic DNS Setup

```bash
# Use DuckDNS for free domain
# Visit https://www.duckdns.org
# Get domain: myserver.duckdns.org
# Copy token

# Create update script
mkdir -p ~/scripts
cat > ~/scripts/duckdns.sh << 'EOF'
#!/bin/bash
DOMAIN="myserver"
TOKEN="your-token-from-duckdns"
echo url="https://www.duckdns.org/update?domains=${DOMAIN}&token=${TOKEN}&ip=" | curl -k -o ~/scripts/duck.log -K -
EOF

chmod +x ~/scripts/duckdns.sh

# Test it
~/scripts/duckdns.sh

# Automate
crontab -e
# Add: */5 * * * * ~/scripts/duckdns.sh
```

#### Step 2: Install Nginx Proxy Manager

```bash
mkdir -p ~/nginx-proxy-manager
cd ~/nginx-proxy-manager

# Create docker-compose.yml (see earlier in document)
cat > docker-compose.yml << 'EOF'
version: '3'
services:
  nginx-proxy-manager:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - '80:80'
      - '443:443'
      - '81:81'
    environment:
      DB_SQLITE_FILE: "/data/database.sqlite"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOF

# Start it
docker-compose up -d

# Wait a minute, then access
# http://your-server-ip:81
```

#### Step 3: Setup Services

```bash
# Create shared network
docker network create proxy

# Create services directory
mkdir -p ~/services
cd ~/services

# Nextcloud
mkdir nextcloud && cd nextcloud
cat > docker-compose.yml << 'EOF'
version: '3'
networks:
  proxy:
    external: true
services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "80"
    volumes:
      - ./data:/var/www/html
EOF

docker-compose up -d
cd ..

# Jellyfin
mkdir jellyfin && cd jellyfin
cat > docker-compose.yml << 'EOF'
version: '3'
networks:
  proxy:
    external: true
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "8096"
    volumes:
      - ./config:/config
      - ~/media:/media
EOF

docker-compose up -d
cd ..
```

#### Step 4: Configure Nginx Proxy Manager

```
Access: http://your-server-ip:81
Login: admin@example.com / changeme
Change password immediately!

Add Proxy Hosts:

1. cloud.myserver.duckdns.org → nextcloud:80
   - Request SSL certificate
   - Force SSL
   - HTTP/2 Support

2. media.myserver.duckdns.org → jellyfin:8096
   - Request SSL certificate
   - Force SSL
   - Websockets Support

3. home.myserver.duckdns.org → homeassistant:8123
   - Request SSL certificate
   - Force SSL
   - Websockets Support
```

#### Step 5: Router Port Forwarding (Surfboard Gateway)

```
Access your Surfboard gateway:
- URL: http://192.168.100.1 (or http://192.168.0.1)
- Login with credentials (check bottom of modem)

Find Port Forwarding section:
- May be under "Advanced" or "NAT"

Add rules:
Service: HTTP
External Port: 80
Internal IP: 192.168.1.100 (your AX8 IP)
Internal Port: 80
Protocol: TCP

Service: HTTPS
External Port: 443
Internal IP: 192.168.1.100
Internal Port: 443
Protocol: TCP

Save and apply changes
```

#### Step 6: Install Tailscale (Admin Access)

```bash
# On your AX8
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Install on your laptop/phone
# Download from https://tailscale.com/download

# Access admin interfaces via Tailscale IP
# Example: http://100.x.x.x:81 (Nginx Proxy Manager admin)
```

#### Step 7: Firewall Configuration

```bash
# Allow HTTP, HTTPS for public services
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Allow Nginx Proxy Manager admin ONLY from Tailscale network
sudo ufw allow from 100.64.0.0/10 to any port 81 comment 'NPM Admin'

# Allow Cockpit from Tailscale only
sudo ufw allow from 100.64.0.0/10 to any port 9090 comment 'Cockpit'

# Enable firewall
sudo ufw enable
```

#### Step 8: Test Everything

```bash
# Test public access (from phone on cellular)
https://cloud.myserver.duckdns.org  # Should show Nextcloud
https://media.myserver.duckdns.org  # Should show Jellyfin

# Test admin access (connected to Tailscale)
http://100.x.x.x:81  # Nginx Proxy Manager admin
http://100.x.x.x:9090  # Cockpit

# Check SSL certificates
openssl s_client -connect cloud.myserver.duckdns.org:443 -servername cloud.myserver.duckdns.org
```

### Costs Summary for Complete Setup

| Item | Cost | Frequency |
|------|------|-----------|
| **DuckDNS** | Free | Forever |
| **Nginx Proxy Manager** | Free | Forever |
| **Docker** | Free | Forever |
| **Tailscale VPN** | Free | Forever (personal) |
| **SSL Certificates (Let's Encrypt)** | Free | Forever |
| **Domain (optional, if you want your own)** | $10-15 | Annual |
| **TOTAL** | **$0** | (or $10-15/year with own domain) |

**Hardware You Already Have:**
- Geekom AX8: Your server
- Surfboard Gateway: Your modem/router
- Comcast Internet: Your ISP

---

## Security Best Practices

### 1. Firewall Rules

```bash
# Default deny everything
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow only what you need
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Rate limit SSH if exposed
sudo ufw limit 22/tcp

# Enable firewall
sudo ufw enable
```

### 2. Fail2Ban (Prevent Brute Force)

```bash
# Install Fail2Ban
sudo apt install -y fail2ban

# Configure for Nginx
sudo nano /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log

[nginx-noscript]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log

[nginx-badbots]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log
```

```bash
# Start Fail2Ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Check status
sudo fail2ban-client status
```

### 3. Keep Everything Updated

```bash
# Create update script
cat > ~/scripts/update-all.sh << 'EOF'
#!/bin/bash

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Updating Docker containers..."
cd ~/nginx-proxy-manager && docker-compose pull && docker-compose up -d
cd ~/services/nextcloud && docker-compose pull && docker-compose up -d
cd ~/services/jellyfin && docker-compose pull && docker-compose up -d

echo "Cleaning up..."
docker system prune -af

echo "Update complete!"
EOF

chmod +x ~/scripts/update-all.sh

# Run weekly
crontab -e
# Add: 0 3 * * 0 ~/scripts/update-all.sh >> ~/scripts/update.log 2>&1
```

### 4. Backup Strategy

```bash
# Backup script
cat > ~/scripts/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup Docker volumes and configs
tar -czf $BACKUP_DIR/docker-backup-$DATE.tar.gz \
    ~/nginx-proxy-manager \
    ~/services

# Keep only last 7 backups
cd $BACKUP_DIR
ls -t | grep docker-backup | tail -n +8 | xargs -r rm

echo "Backup completed: $BACKUP_DIR/docker-backup-$DATE.tar.gz"
EOF

chmod +x ~/scripts/backup.sh

# Run daily
crontab -e
# Add: 0 2 * * * ~/scripts/backup.sh
```

### 5. Monitoring

```bash
# Install monitoring tools
sudo apt install -y htop iotop nethogs

# Setup Uptime Kuma for service monitoring
docker run -d \
  --name uptime-kuma \
  --restart unless-stopped \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  louislam/uptime-kuma:1

# Access at http://your-tailscale-ip:3001
```

---

## Troubleshooting

### Cannot Access Services from Internet

1. **Check Dynamic DNS:**
   ```bash
   # Verify your domain resolves to correct IP
   nslookup myserver.duckdns.org
   
   # Compare with your public IP
   curl ifconfig.me
   ```

2. **Check Port Forwarding:**
   - Log into Surfboard gateway
   - Verify port forwarding rules
   - Check internal IP is correct

3. **Check Firewall:**
   ```bash
   sudo ufw status verbose
   ```

4. **Check Docker Containers:**
   ```bash
   docker ps
   docker logs nginx-proxy-manager
   docker logs nextcloud
   ```

5. **Check Nginx Proxy Manager:**
   - Access admin panel: http://your-local-ip:81
   - Verify proxy host configuration
   - Check SSL certificate status

### Services Work Locally but Not Externally

- ISP might be blocking ports 80/443
- Test from cellular network (not home WiFi)
- Try accessing via mobile hotspot
- Contact ISP if ports are blocked
- Consider using Cloudflare tunnel as alternative

### SSL Certificate Issues

```bash
# Check certificate in NPM
# Proxy Hosts → Edit → SSL → View Certificate

# If expired, try requesting new certificate
# Delete old certificate and request again

# Check Let's Encrypt rate limits
# https://letsencrypt.org/docs/rate-limits/
```

### VPN Not Connecting

**Tailscale:**
```bash
# Check status
sudo tailscale status

# Restart service
sudo systemctl restart tailscaled

# Check logs
sudo journalctl -u tailscaled -f
```

**WireGuard:**
```bash
# Check if running
sudo wg show

# Check logs
sudo journalctl -u wg-quick@wg0 -f

# Verify port forwarding (UDP 51820)
```

---

## Additional Resources

### Documentation
- **Nginx Proxy Manager:** https://nginxproxymanager.com/
- **Docker:** https://docs.docker.com/
- **Tailscale:** https://tailscale.com/kb/
- **WireGuard:** https://www.wireguard.com/
- **DuckDNS:** https://www.duckdns.org/spec.jsp
- **Let's Encrypt:** https://letsencrypt.org/docs/

### Communities
- **r/selfhosted** on Reddit: Great community for self-hosting
- **Nginx Proxy Manager Discord:** Active support community
- **Docker Forums:** https://forums.docker.com/
- **Tailscale Community:** https://forum.tailscale.com/

### Video Tutorials
- Search YouTube for: "Nginx Proxy Manager setup"
- Search YouTube for: "Docker Compose tutorial"
- Search YouTube for: "Tailscale home server"

---

## Conclusion

**Your Recommended Setup:**

1. **Web Server:** Nginx (via Nginx Proxy Manager)
   - Easy GUI management
   - Automatic SSL
   - Perfect for multiple services

2. **Dynamic DNS:** DuckDNS (free)
   - Simple and reliable
   - Works great with Comcast

3. **Docker Management:** Nginx Proxy Manager + Portainer
   - NPM for routing/SSL
   - Portainer for container management

4. **VPN:** Tailscale (free)
   - Zero configuration
   - Perfect for admin access
   - No port forwarding needed

5. **Port Forwarding:** Only 80 and 443
   - Minimal exposure
   - All services via reverse proxy

**Total Cost: $0 per month**

This setup gives you:
- ✅ Professional public services with SSL
- ✅ Secure admin access via VPN
- ✅ Easy management through web UIs
- ✅ Minimal port forwarding (better security)
- ✅ No ongoing costs
- ✅ Scalable for many services

You now have a complete, production-ready home server setup that's secure, accessible, and easy to manage!
