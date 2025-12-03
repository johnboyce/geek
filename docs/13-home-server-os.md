# Home Server Operating Systems

## Overview

The Geekom AX8 makes an excellent home server platform with its powerful AMD Ryzen 9 8945HS processor, compact form factor, and low power consumption. This guide covers various operating systems optimized for home server use, from beginner-friendly options to advanced platforms.

## Why Use a Home Server OS?

**Benefits:**
- Centralized data storage and backup
- Self-hosted applications (cloud storage, media streaming, automation)
- Privacy and data ownership
- Learning platform for server administration
- Cost savings over cloud subscriptions
- 24/7 availability for services

**Ideal Use Cases:**
- File sharing and backup
- Media server (Plex, Jellyfin)
- Home automation hub
- Development/testing environment
- Network-attached storage (NAS)
- Self-hosted applications (password managers, document storage, etc.)

## Recommended Home Server Operating Systems

### 1. CasaOS (Easiest - Recommended for Beginners)

**What is CasaOS?**
CasaOS is a beautiful, easy-to-use home cloud system based on Docker. It provides a clean web interface for managing applications and services without command-line knowledge.

**Key Features:**
- Simple, elegant web UI
- One-click app installation from app store
- Docker-based architecture
- Built-in file manager
- User-friendly dashboard
- Active development and community
- Low resource overhead
- Perfect for the AX8's capabilities

**Installation on Ubuntu/Debian:**
```bash
# Install CasaOS with one command
curl -fsSL https://get.casaos.io | sudo bash

# Or manual installation
wget -qO- https://get.casaos.io | sudo bash

# Access web interface
# Open browser to: http://your-ax8-ip
# Default port: 80 (HTTP)
```

**After Installation:**
1. Open web browser to `http://<your-ax8-ip>`
2. Create your admin account
3. Explore the App Store for ready-to-use applications
4. Install apps like:
   - Jellyfin (media server)
   - Nextcloud (file sync and share)
   - Home Assistant (home automation)
   - Vaultwarden (password manager)
   - qBittorrent (download manager)

**System Requirements:**
- Minimum: 1GB RAM, 2-core CPU
- Recommended for AX8: Use default installation (plenty of resources)
- Storage: 5GB for system, additional for apps and data

**Pros:**
- Extremely user-friendly
- Beautiful interface
- Fast setup (5 minutes)
- Great app ecosystem
- Regular updates
- Low learning curve

**Cons:**
- Less control than traditional Linux
- Smaller app library than mature platforms
- Relatively new project (less documentation)

**Best For:** First-time home server users, those wanting quick setup

---

### 2. Cosmos Cloud

**What is Cosmos Cloud?**
A modern, self-hosted cloud platform with focus on security and ease of use. Features automatic HTTPS, reverse proxy, and authentication.

**Key Features:**
- Secure by default (automatic HTTPS)
- Built-in reverse proxy
- User authentication system
- Docker container management
- Application marketplace
- VPN integration
- Modern web interface

**Installation:**
```bash
# Install Docker first (if not already installed)
curl -fsSL https://get.docker.com | sudo bash

# Install Cosmos
docker run -d \
  --name cosmos-server \
  --restart=always \
  -p 80:80 \
  -p 443:443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/cosmos:/config \
  azukaar/cosmos-server:latest

# Access at https://your-ax8-ip
```

**Pros:**
- Strong security features
- Automatic SSL certificates
- Clean, modern UI
- Good documentation
- Active development

**Cons:**
- More complex than CasaOS
- Requires some networking knowledge
- Smaller community

**Best For:** Users who prioritize security and want automatic HTTPS

---

### 3. Umbrel

**What is Umbrel?**
Originally designed for Bitcoin nodes, Umbrel has evolved into a comprehensive home server OS with beautiful UI and extensive app store.

**Key Features:**
- Stunning user interface
- Large app store (80+ apps)
- One-click installations
- Built-in Bitcoin/Lightning node
- Automatic backups
- Mobile app support
- Docker-based

**Installation:**
```bash
# Install Umbrel
curl -L https://umbrel.sh | bash

# Access web interface
# Open browser to: http://umbrel.local
# Or: http://your-ax8-ip
```

**Popular Apps:**
- Bitcoin Node & Lightning
- Nextcloud (file storage)
- Jellyfin & Plex (media)
- Pi-hole (ad blocking)
- Bitwarden (password manager)
- Syncthing (file sync)
- Home Assistant
- Code Server (VS Code in browser)

**System Requirements:**
- Minimum: 4GB RAM (8GB recommended)
- Storage: 10GB+ for OS, 1TB+ recommended for data
- The AX8 is perfect for Umbrel

**Pros:**
- Beautiful, polished interface
- Comprehensive app store
- Strong community
- Regular updates
- Excellent for cryptocurrency users
- Mobile app

**Cons:**
- Higher resource usage
- Some features focused on crypto
- Requires more storage

**Best For:** Users wanting a polished experience, crypto enthusiasts

---

### 4. TrueNAS SCALE

**What is TrueNAS SCALE?**
Enterprise-grade NAS operating system based on Debian Linux. Excellent for data storage and protection with ZFS filesystem.

**Key Features:**
- ZFS filesystem (advanced data protection)
- Built-in virtualization (KVM)
- Docker and Kubernetes support
- Enterprise features
- Comprehensive backup solutions
- Extensive plugin ecosystem
- Web-based management

**Installation:**
1. Download TrueNAS SCALE ISO from https://www.truenas.com/
2. Create bootable USB using Balena Etcher
3. Boot from USB and follow installation wizard
4. Configure storage pools and shares

**Pros:**
- Enterprise-grade stability
- ZFS data integrity
- Powerful storage management
- Virtualization support
- Professional support available
- Excellent documentation

**Cons:**
- Steeper learning curve
- Requires dedicated storage drives for best ZFS performance
- More complex setup
- Overkill for simple use cases

**Best For:** Advanced users, those prioritizing data integrity, NAS-focused setups

---

### 5. OpenMediaVault (OMV)

**What is OpenMediaVault?**
Free, Debian-based NAS solution focused on simplicity and modularity through plugins.

**Key Features:**
- Web-based administration
- Extensive plugin system
- Support for multiple filesystems
- RAID management
- SMB/NFS/FTP sharing
- Docker support via plugins
- Active community

**Installation:**
```bash
# On existing Debian/Ubuntu system
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash

# Or install from ISO (download from openmediavault.org)
# Boot from USB and follow installer
```

**Pros:**
- Lightweight
- Very stable
- Extensive plugins
- Good for NAS use
- Active community
- Regular updates

**Cons:**
- Interface less modern
- Some features require plugins
- Learning curve for advanced features

**Best For:** Dedicated NAS setups, users familiar with Linux

---

### 6. Proxmox VE

**What is Proxmox?**
Enterprise virtualization platform for running VMs and containers. Perfect for running multiple services isolated.

**Key Features:**
- KVM virtualization
- LXC containers
- Web-based management
- High availability clustering
- Backup and restore
- Software-defined storage
- Enterprise support available

**Installation:**
1. Download Proxmox VE ISO from https://www.proxmox.com/
2. Create bootable USB
3. Install Proxmox (replaces existing OS)
4. Access web interface at https://your-ax8-ip:8006

**Use Cases on AX8:**
- Run multiple OS instances
- Isolated services for security
- Testing environment
- Development platforms
- Home lab

**Pros:**
- Professional virtualization
- Excellent for running multiple services
- Strong web interface
- Good documentation
- Large community

**Cons:**
- Requires more system resources
- More complex than simple app platforms
- Subscription for enterprise repos (optional)

**Best For:** Advanced users, home lab enthusiasts, those running multiple VMs

---

### 7. YunoHost

**What is YunoHost?**
Server OS that makes self-hosting accessible to everyone. Based on Debian with focus on simplicity.

**Key Features:**
- Simple web administration
- Integrated app store
- User management
- Email server included
- Automatic backups
- Domain and certificate management
- LDAP authentication

**Installation:**
```bash
# On existing Debian system
curl https://install.yunohost.org | bash

# Access via browser
# Follow post-installation wizard
```

**Pros:**
- Very easy to use
- Good app selection
- Integrated email server
- Strong security defaults
- Good for beginners

**Cons:**
- Less flexible than others
- Smaller community than alternatives
- Some apps may be outdated

**Best For:** Users wanting email server, those new to self-hosting

---

## Comparison Table

| OS | Difficulty | Resource Usage | UI Quality | App Store | Best Use Case |
|---|---|---|---|---|---|
| **CasaOS** | Easy | Low | Excellent | Good | General home server, beginners |
| **Cosmos Cloud** | Medium | Low | Excellent | Growing | Security-focused users |
| **Umbrel** | Easy | Medium | Excellent | Large | Polished experience, crypto |
| **TrueNAS SCALE** | Hard | Medium-High | Good | Medium | Data storage, NAS |
| **OpenMediaVault** | Medium | Low | Fair | Large | Traditional NAS |
| **Proxmox VE** | Hard | High | Good | N/A | Virtualization, home lab |
| **YunoHost** | Easy | Low | Good | Good | Email + apps, simplicity |

## Installation Recommendations for Geekom AX8

### Beginner Setup (Easiest)
1. Install Ubuntu 24.04 LTS (base OS)
2. Install CasaOS on top
3. Use CasaOS app store for applications
4. Access via web browser

### Advanced Setup (Most Flexible)
1. Install Proxmox VE (bare metal)
2. Create Ubuntu VM for general services
3. Create specialized VMs for different purposes
4. Install CasaOS or other platforms inside VMs

### NAS-Focused Setup
1. Install TrueNAS SCALE or OpenMediaVault
2. Configure storage pools
3. Add Docker support for applications
4. Use as primary storage server

## Post-Installation Steps

### Regardless of OS chosen:

1. **Set Static IP:**
```bash
# Ensure your AX8 has a consistent IP address
# Configure in your router's DHCP settings
# Or set static IP in the OS network settings
```

2. **Enable Automatic Updates:**
```bash
# Most platforms have this in settings
# Or for Ubuntu base:
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

3. **Configure Firewall:**
```bash
# Ubuntu/Debian base
sudo ufw enable
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 2222/tcp  # SSH (if changed from 22)
```

4. **Set Up Backups:**
- Configure automatic backups of critical data
- Use external drive or cloud backup
- Test restore procedures

5. **Access from Anywhere (Optional):**
- Set up Tailscale VPN (recommended)
- Or configure port forwarding (security risk)
- Use dynamic DNS if needed

## Security Best Practices

1. **Change Default Passwords:** Immediately change all default credentials
2. **Enable HTTPS:** Use Let's Encrypt for free SSL certificates
3. **Use VPN:** Access remotely via Tailscale or WireGuard
4. **Regular Updates:** Keep OS and applications updated
5. **Backups:** Implement 3-2-1 backup strategy
6. **Monitoring:** Set up alerts for issues
7. **Firewall:** Only expose necessary ports

## Common Applications to Install

### Media Server
- **Jellyfin**: Free, open-source media system
- **Plex**: Popular media server with apps
- **Emby**: Alternative to Plex

### Cloud Storage
- **Nextcloud**: Self-hosted cloud storage and office
- **Seafile**: Fast, reliable file sync
- **Syncthing**: Decentralized sync

### Home Automation
- **Home Assistant**: Comprehensive home automation
- **Node-RED**: Visual programming for IoT

### Development
- **Code-Server**: VS Code in browser
- **Gitea**: Self-hosted Git service
- **Jenkins**: Automation server

### Security & Privacy
- **Vaultwarden**: Password manager (Bitwarden)
- **Pi-hole**: Network-wide ad blocking
- **AdGuard Home**: Alternative ad blocker

### Utilities
- **Portainer**: Docker management UI
- **Uptime Kuma**: Monitoring tool
- **Homer**: Application dashboard

## Troubleshooting

### Can't Access Web Interface
```bash
# Check if service is running
sudo systemctl status casaos  # or relevant service

# Check firewall
sudo ufw status

# Verify IP address
ip addr show
```

### High Resource Usage
```bash
# Check resource usage
htop

# Check Docker containers
docker stats

# Restart problematic containers
docker restart <container-name>
```

### Storage Issues
```bash
# Check disk space
df -h

# Check Docker space
docker system df

# Clean up Docker
docker system prune -a
```

## Additional Resources

- **CasaOS Documentation**: https://casaos.io/docs
- **Umbrel Documentation**: https://umbrel.com/docs
- **TrueNAS Documentation**: https://www.truenas.com/docs/
- **Proxmox Documentation**: https://pve.proxmox.com/wiki/
- **Self-Hosted Community**: https://reddit.com/r/selfhosted
- **Awesome Self-Hosted**: https://github.com/awesome-selfhosted/awesome-selfhosted

## Conclusion

For most Geekom AX8 users, **CasaOS** provides the best balance of ease-of-use and functionality. It's perfect for:
- First-time home server users
- Those wanting quick results
- Users preferring GUI over command line
- Running multiple Docker applications

For advanced users or specific needs:
- **Proxmox VE**: Maximum flexibility with VMs
- **TrueNAS SCALE**: Best for data integrity and NAS
- **Umbrel**: Most polished experience with crypto features
- **Cosmos Cloud**: Security-focused with auto-HTTPS

The AX8's powerful hardware can easily handle any of these platforms, often running multiple services simultaneously without breaking a sweat.
