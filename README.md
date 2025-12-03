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

**📖 [View Documentation Online](https://johnboyce.github.io/geek/)** - Browse the documentation through our GitHub Pages site for the best reading experience.

## Quick Start

### View Documentation Online

**🌐 [Visit the GitHub Pages Site](https://johnboyce.github.io/geek/)**

The easiest way to browse the documentation is through our GitHub Pages site, which provides a clean, responsive interface with search functionality.

> **Note**: GitHub Pages is automatically deployed from the `main` branch. If you encounter a 404 error, ensure GitHub Pages is configured to use "GitHub Actions" as the source (Repository Settings → Pages → Source: GitHub Actions). See [CONTRIBUTING.md](CONTRIBUTING.md#github-pages-deployment) for more details.

### View Documentation Locally

Browse the documentation in the `docs/` directory (organized in chronological setup order):

1. [Hardware Specifications](docs/01-hardware-specs.md) - Including AI capabilities
2. [BIOS Configuration](docs/02-bios-configuration.md) - Configure before OS installation
3. [Linux Installation](docs/03-linux-installation.md) - Includes USB creation guide for MacBook M3
4. [Peripheral Setup](docs/04-peripheral-setup.md) - RedThunder keyboard/mouse, SSK USB-C drive, Acer monitor
5. [Development Setup](docs/05-development-setup.md) - Programming languages, IDEs, and tools
6. [AI & Machine Learning Setup](docs/06-ai-ml-setup.md) - Leverage Ryzen AI NPU for ML workloads
7. [Security Configuration](docs/07-security-configuration.md) - Harden your system
8. [Remote Access](docs/08-remote-access.md) - SSH, VNC, RDP, and web management
9. [Gaming Setup](docs/09-gaming-setup.md) - Steam, Proton, and game optimization
10. [Video Streaming](docs/10-video-streaming.md) - OBS, media servers, and streaming
11. [Cool Tools](docs/11-cool-tools.md) - System monitoring, benchmarking, and management tools
12. [Troubleshooting](docs/12-troubleshooting.md) - Solutions for common issues

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
- **Hardware**: Optimized for Geekom AX8 (AMD Ryzen 9 8945HS with Ryzen AI NPU, Radeon 780M)
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

## Documentation Migration

**Note**: Root-level documentation files (`linux-installation-guide.md` and `peripheral-setup.md`) have been consolidated into the `docs/` directory for better organization. See [DEPRECATED.md](DEPRECATED.md) for details.

All documentation is now in the `docs/` directory with enhanced content including **MacBook M3** specific instructions for creating bootable USB drives.

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
