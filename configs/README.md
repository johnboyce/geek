# Configuration Templates

This directory contains sample configuration files referenced in the documentation.

## Available Templates

### Security
- `ufw-rules.sh` - Firewall configuration script
- `ssh_config.example` - Hardened SSH configuration
- `fail2ban-jail.conf` - Fail2Ban configuration

### Remote Access
- `vnc-xstartup.sh` - VNC startup script
- `wireguard-server.conf` - WireGuard VPN server configuration
- `wireguard-client.conf` - WireGuard VPN client configuration

### Development
- `.bashrc.example` - Enhanced bash configuration
- `.zshrc.example` - Zsh configuration with plugins
- `.gitconfig.example` - Git configuration

### Media/Streaming
- `nginx-rtmp.conf` - RTMP streaming server configuration
- `obs-settings.json` - OBS Studio recommended settings

## Usage

Copy the example files and customize them for your setup:

```bash
# Example: UFW firewall rules
cp configs/ufw-rules.sh ~/setup/
chmod +x ~/setup/ufw-rules.sh
# Edit the file to match your needs
nano ~/setup/ufw-rules.sh
# Run the script
sudo ~/setup/ufw-rules.sh
```

## Notes

- Always review and customize configurations before applying
- Backup existing configurations before replacing
- Test configurations in a safe environment first
- Keep security credentials separate and secure
