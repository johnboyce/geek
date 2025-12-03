# Geekom AX8 Linux Setup Guide

Complete documentation and management application for setting up and configuring a Geekom AX8 mini PC with Linux.

## Overview

This repository provides comprehensive documentation for:
- Setting up Linux on the Geekom AX8 mini PC
- Configuring a development environment
- Security hardening and best practices
- Remote access (SSH, VNC, RDP)
- Gaming setup and optimization
- Video streaming and media server configuration
- Port forwarding and network configuration
- Troubleshooting common issues

## Quick Start

### View Documentation

Browse the documentation in the `docs/` directory:

1. [Hardware Specifications](docs/01-hardware-specs.md)
2. [Linux Installation](docs/02-linux-installation.md) - Includes USB creation guide for MacBook M3
3. [Development Setup](docs/03-development-setup.md)
4. [Security Configuration](docs/04-security-configuration.md)
5. [Remote Access](docs/05-remote-access.md)
6. [Gaming Setup](docs/06-gaming-setup.md)
7. [Video Streaming](docs/07-video-streaming.md)
8. [Troubleshooting](docs/08-troubleshooting.md)
9. [Peripheral Setup](docs/09-peripheral-setup.md) - RedThunder keyboard/mouse, SSK USB-C drive, Acer monitor

### Run the Documentation Web App

Using npm:
```bash
# Install dependencies
npm install

# Start the application
npm start

# Open browser to http://localhost:3000
```

Or using the Makefile (recommended for MacBook M3):
```bash
# Install dependencies
make install

# Start development server
make dev

# Open browser to http://localhost:3000
```

For more commands, run `make help`

## Features

### Documentation Coverage

- **Hardware Overview**: Detailed specs and capabilities of the Geekom AX8
- **Installation Guide**: Step-by-step Linux installation with recommended distributions
- **Development Environment**: Complete setup for Node.js, Python, Go, Rust, Java, Docker, and databases
- **Security**: Firewall, SSH hardening, Fail2Ban, VPN setup, and security auditing
- **Remote Access**: SSH, VNC, RDP, NoMachine, and Tailscale configurations
- **Gaming**: Steam, Proton, Lutris, performance optimization, and controller setup
- **Streaming**: OBS, FFmpeg, Plex, Jellyfin, and hardware-accelerated transcoding
- **Troubleshooting**: Solutions for common issues and system recovery

### Web Application Features

- Clean, responsive interface
- Search functionality
- Syntax highlighting for code blocks
- Mobile-friendly design
- Easy navigation between topics
- Printable documentation

## Requirements

- Node.js 18 or higher
- npm or yarn
- Modern web browser

## Installation

### Using Makefile (Recommended for MacBook M3)

```bash
# Clone repository
git clone https://github.com/johnboyce/geek.git
cd geek

# Install dependencies
make install

# Start development server
make dev

# Or start production server
make start

# View all available commands
make help
```

### Using npm

```bash
# Clone repository
git clone https://github.com/johnboyce/geek.git
cd geek

# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

## Project Structure

```
geek/
├── docs/                   # Markdown documentation
│   ├── 01-hardware-specs.md
│   ├── 02-linux-installation.md
│   ├── 03-development-setup.md
│   ├── 04-security-configuration.md
│   ├── 05-remote-access.md
│   ├── 06-gaming-setup.md
│   ├── 07-video-streaming.md
│   └── 08-troubleshooting.md
├── public/                 # Static assets
├── src/                    # Application source code
│   ├── components/         # React components
│   ├── styles/            # CSS styles
│   └── App.js             # Main application
├── package.json
└── README.md
```

## Usage

### Viewing Documentation

The web application provides an intuitive interface to browse all documentation. Simply run `npm start` and navigate to `http://localhost:3000`.

### Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- Documentation improvements
- New guides or tutorials
- Bug fixes
- Feature requests

## Use Cases

This documentation is designed for:

1. **Software Developers**: Complete development environment setup with modern tooling
2. **System Administrators**: Security hardening and remote access configuration
3. **Gamers**: Gaming on Linux with performance optimization
4. **Content Creators**: Streaming and media server setup
5. **General Users**: Comprehensive Linux setup guide

## Supported Configurations

- **Operating System**: Ubuntu 24.04 LTS, Fedora 40+, Pop!_OS 22.04, and other modern Linux distributions
- **Hardware**: Optimized for Geekom AX8 (AMD Ryzen 9 8945HS, Radeon 780M)
- **Use Cases**: Development, gaming, streaming, remote work, home server

## Security Considerations

This documentation includes comprehensive security guidance:
- Firewall configuration (UFW)
- SSH hardening with key-only authentication
- Fail2Ban for intrusion prevention
- VPN setup with WireGuard
- Security auditing tools
- Encryption and backup strategies

Always review security recommendations before exposing services to the internet.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Geekom for creating the AX8 mini PC
- The Linux community for excellent documentation and tools
- Contributors to this documentation

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Submit a pull request
- Check the troubleshooting guide

## Roadmap

- [ ] Additional security hardening guides
- [ ] Container orchestration (Kubernetes/Docker Swarm)
- [ ] Home automation integration
- [ ] Advanced networking configurations
- [ ] Automated setup scripts
- [ ] Video tutorials
- [ ] Configuration backup/restore tools

## Stay Updated

Star this repository to stay updated with new documentation and features!
