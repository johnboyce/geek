# Security Configuration Guide

## System Hardening Basics

### Keep System Updated
```bash
# Enable automatic security updates
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Manual updates
sudo apt update && sudo apt upgrade -y
```

### Firewall Configuration

#### UFW (Uncomplicated Firewall)
```bash
# Install and enable UFW
sudo apt install -y ufw

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (IMPORTANT: Do this before enabling!)
sudo ufw allow 22/tcp comment 'SSH'

# Allow common development ports
sudo ufw allow 3000/tcp comment 'Node.js Dev'
sudo ufw allow 8080/tcp comment 'HTTP Alt'
sudo ufw allow 5000/tcp comment 'Flask/Python'

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```

#### Advanced Firewall Rules
```bash
# Rate limit SSH to prevent brute force
sudo ufw limit 22/tcp

# Allow from specific IP only
sudo ufw allow from 192.168.1.100 to any port 22

# Allow Docker subnet
sudo ufw allow from 172.17.0.0/16

# Allow local network
sudo ufw allow from 192.168.1.0/24

# Delete a rule
sudo ufw status numbered
sudo ufw delete [number]
```

### SSH Hardening

#### Configure SSH Server
```bash
# Backup original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

Recommended SSH settings:
```
# /etc/ssh/sshd_config

# Change default port (optional but recommended)
Port 2222

# Disable root login
PermitRootLogin no

# Disable password authentication (use keys only)
PasswordAuthentication no
PubkeyAuthentication yes

# Disable empty passwords
PermitEmptyPasswords no

# Limit authentication attempts
MaxAuthTries 3

# Use strong ciphers only
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256

# Disable X11 forwarding if not needed
X11Forwarding no

# Set login grace time
LoginGraceTime 30

# Allow specific users only (optional)
AllowUsers yourusername

# Disconnect idle sessions
ClientAliveInterval 300
ClientAliveCountMax 2
```

Apply changes:
```bash
# Test configuration
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd

# Update firewall if you changed the port
sudo ufw allow 2222/tcp comment 'SSH Custom Port'
sudo ufw delete allow 22/tcp
```

### Fail2Ban - Intrusion Prevention

```bash
# Install Fail2Ban
sudo apt install -y fail2ban

# Create local configuration
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit configuration
sudo nano /etc/fail2ban/jail.local
```

Key Fail2Ban settings:
```ini
[DEFAULT]
# Ban time (10 minutes)
bantime = 600

# Time window to count failures (10 minutes)
findtime = 600

# Number of failures before ban
maxretry = 5

# Email notifications (optional)
destemail = your-email@example.com
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = 2222
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

Enable and start:
```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

## User Account Security

### Strong Password Policy
```bash
# Install password quality checker
sudo apt install -y libpam-pwquality

# Configure password policy
sudo nano /etc/security/pwquality.conf
```

Recommended settings:
```
minlen = 12
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
```

### Sudo Configuration
```bash
# Require password for sudo
sudo visudo
```

Add/modify:
```
# Require password every time
Defaults    timestamp_timeout=0

# Log all sudo commands
Defaults    log_input, log_output
Defaults    logfile="/var/log/sudo.log"
```

## Application Security

### Docker Security

#### Run Docker in rootless mode
```bash
# Install rootless Docker
dockerd-rootless-setuptool.sh install

# Set Docker context
systemctl --user enable docker
systemctl --user start docker
```

#### Docker security best practices
```bash
# Use non-root user in Dockerfiles
# Dockerfile example:
# FROM node:18
# RUN useradd -m -u 1001 appuser
# USER appuser

# Scan images for vulnerabilities
docker scan your-image:tag

# Limit container resources
docker run --memory="512m" --cpus="1" your-image
```

### Web Application Firewall (nginx)

```bash
sudo apt install -y nginx

# Install ModSecurity
sudo apt install -y libnginx-mod-security

# Configure HTTPS with Let's Encrypt (when publicly accessible)
sudo apt install -y certbot python3-certbot-nginx
```

## Network Security

### Port Forwarding Security

When setting up port forwarding on your router:

1. **Use Non-Standard Ports**: Forward external port 2222 → internal port 22
2. **Use VPN Instead**: Consider OpenVPN/WireGuard instead of direct port forwarding
3. **Limit IP Ranges**: Configure router to allow only from specific IPs
4. **Enable Logging**: Monitor access attempts

### VPN Setup (WireGuard)

```bash
# Install WireGuard
sudo apt install -y wireguard

# Generate keys
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey

# Create config
sudo nano /etc/wireguard/wg0.conf
```

Example server configuration:
```ini
[Interface]
PrivateKey = <server-private-key>
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = true

# Enable IP forwarding
PostUp = sysctl -w net.ipv4.ip_forward=1
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.0.0.2/32
```

Enable WireGuard:
```bash
# Enable and start
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0

# Allow through firewall
sudo ufw allow 51820/udp
```

## Monitoring and Logging

### System Logging
```bash
# Install log monitoring tools
sudo apt install -y rsyslog logwatch

# Configure logwatch
sudo nano /etc/logwatch/conf/logwatch.conf
```

### Security Auditing

#### Lynis - Security Auditing
```bash
# Install Lynis
sudo apt install -y lynis

# Run security audit
sudo lynis audit system

# Review recommendations
sudo cat /var/log/lynis.log
```

#### ClamAV - Antivirus
```bash
# Install ClamAV
sudo apt install -y clamav clamav-daemon

# Update virus definitions
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam

# Scan home directory
clamscan -r -i /home/
```

#### RKHunter - Rootkit Detection
```bash
sudo apt install -y rkhunter

# Update and run
sudo rkhunter --update
sudo rkhunter --check
```

## Data Encryption

### Encrypt Home Directory (for new users)
```bash
sudo apt install -y ecryptfs-utils

# Create encrypted user
sudo adduser --encrypt-home newuser
```

### Full Disk Encryption (LUKS)
Note: Should be set up during installation, but can encrypt additional drives:

```bash
# Encrypt a new partition
sudo cryptsetup luksFormat /dev/sdX
sudo cryptsetup luksOpen /dev/sdX encrypted_drive
sudo mkfs.ext4 /dev/mapper/encrypted_drive
```

### Encrypt Backups
```bash
# Using restic with encryption
restic init --repo /path/to/backup
restic backup /path/to/data --repo /path/to/backup
```

## Security Checklist

- [ ] System updates enabled and automatic
- [ ] Firewall configured and active
- [ ] SSH hardened (key-only, non-standard port)
- [ ] Fail2Ban installed and configured
- [ ] Strong password policy enforced
- [ ] Docker running rootless (if applicable)
- [ ] VPN configured for remote access
- [ ] Regular security audits scheduled
- [ ] Backups encrypted and tested
- [ ] Logs monitored regularly
- [ ] Unnecessary services disabled
- [ ] System audit tools installed (Lynis, RKHunter)

## Security Maintenance

### Weekly Tasks
```bash
# Check failed login attempts
sudo lastb

# Review firewall logs
sudo grep -i UFW /var/log/syslog | tail -50

# Check Fail2Ban status
sudo fail2ban-client status sshd
```

### Monthly Tasks
```bash
# Run security audit
sudo lynis audit system

# Check for rootkits
sudo rkhunter --check

# Review user accounts
sudo cat /etc/passwd | grep /bin/bash

# Check for unusual open ports
sudo netstat -tulpn
```

### Incident Response Plan

If you suspect a security breach:

1. **Disconnect from network immediately**
2. **Check running processes**: `ps aux`, `top`, `htop`
3. **Check network connections**: `netstat -tulpn`, `ss -tulpn`
4. **Review recent logins**: `last`, `lastb`, `who`
5. **Check system logs**: `/var/log/auth.log`, `/var/log/syslog`
6. **Scan for malware**: `sudo clamscan -r /`
7. **Change all passwords**
8. **Review and rotate SSH keys**
9. **Restore from known-good backup if needed**
