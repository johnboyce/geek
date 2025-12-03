#!/bin/bash
# UFW Firewall Configuration Script
# Review and customize before running

echo "=========================================="
echo "UFW Firewall Configuration Script"
echo "=========================================="
echo ""
echo "This script will configure your firewall rules."
echo "Please review the settings before proceeding."
echo ""
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Configuration cancelled."
    exit 0
fi

echo ""
echo "Configuring UFW Firewall..."

# ⚠️  WARNING: Reset UFW to defaults (NOT RECOMMENDED - see ufw-reset.sh instead)
# ⚠️  This will REMOVE ALL EXISTING FIREWALL RULES!
# ⚠️  If you're connected via SSH and don't have physical access, make sure SSH rules are
# ⚠️  configured below BEFORE uncommenting this line, or you may be locked out!
# ⚠️  Consider using the separate ufw-reset.sh script with additional safety checks.
# sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (IMPORTANT: Adjust port if you changed it)
sudo ufw allow 22/tcp comment 'SSH'
# If using custom SSH port:
# sudo ufw allow 2222/tcp comment 'SSH Custom Port'

# Allow SSH from specific IP only (recommended for production)
# sudo ufw allow from 192.168.1.100 to any port 22 comment 'SSH from specific IP'

# Rate limit SSH to prevent brute force
sudo ufw limit 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Allow development ports (comment out what you don't need)
sudo ufw allow 3000/tcp comment 'Node.js Dev'
sudo ufw allow 8080/tcp comment 'HTTP Alt'
sudo ufw allow 5000/tcp comment 'Flask/Python'
sudo ufw allow 3306/tcp comment 'MySQL'
sudo ufw allow 5432/tcp comment 'PostgreSQL'
sudo ufw allow 27017/tcp comment 'MongoDB'
sudo ufw allow 6379/tcp comment 'Redis'

# Allow VNC (from local network only)
# sudo ufw allow from 192.168.1.0/24 to any port 5901 comment 'VNC'

# Allow RDP (from local network only)
# sudo ufw allow from 192.168.1.0/24 to any port 3389 comment 'RDP'

# Allow WireGuard VPN
# sudo ufw allow 51820/udp comment 'WireGuard'

# Allow Tailscale
sudo ufw allow 41641/udp comment 'Tailscale'

# Allow Plex Media Server
# sudo ufw allow 32400/tcp comment 'Plex'

# Allow Jellyfin
# sudo ufw allow 8096/tcp comment 'Jellyfin'

# Allow Docker subnet
sudo ufw allow from 172.17.0.0/16

# Allow local network
sudo ufw allow from 192.168.1.0/24

# Enable UFW
sudo ufw --force enable

# Show status
sudo ufw status verbose

echo "UFW configuration complete!"
echo "Review the rules above and adjust as needed."
