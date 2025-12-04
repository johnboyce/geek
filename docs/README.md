# Geekom AX8 Documentation Index

This directory contains comprehensive documentation for setting up and managing your Geekom AX8 mini PC with Linux.

## Documentation Guide

### 1. [Hardware Specifications](01-hardware-specs.md)
Complete hardware specifications of the Geekom AX8, including:
- Processor, GPU, and memory details
- **AMD EXPO** (Extended Profiles for Overclocking) support
- **AI Capabilities** (Ryzen AI NPU with 16 TOPS)
- Connectivity options
- Performance expectations for different workloads

### 2. [BIOS Configuration](02-bios-configuration.md)
**Configure BIOS before installing the operating system:**
- Accessing the BIOS
- Optimal settings for Linux
- **AMD EXPO configuration** for memory overclocking
- BIOS update procedures
- Performance tuning
- Troubleshooting BIOS issues

### 3. [Linux Installation](03-linux-installation.md)
Step-by-step guide for installing Linux:
- Recommended distributions for different use cases
- Installation process and partitioning
- Post-installation setup
- USB creation guide for MacBook M3

### 4. [Peripheral Setup](04-peripheral-setup.md)
**Set up peripherals after OS installation:**
- RedThunder K84 wireless keyboard and mouse
- SSK 128GB USB-C flash drive
- Acer Nitro KG241Y gaming monitor
- Performance benchmarking
- Troubleshooting guides

### 5. [Development Setup](05-development-setup.md)
Complete development environment configuration:
- Version control (Git)
- Programming languages (Node.js, Python, Go, Rust, Java)
- Docker and containers
- Database systems (PostgreSQL, MySQL, MongoDB, Redis)
- IDEs and editors
- Shell enhancements

### 6. [AI & Machine Learning Setup](06-ai-ml-setup.md)
**NEW: Leverage the Ryzen AI NPU for ML workloads:**
- AMD Ryzen AI (XDNA NPU) overview
- Python ML environment setup
- PyTorch and TensorFlow with ROCm
- ONNX Runtime for NPU acceleration
- Running local LLMs (Ollama, LM Studio)
- Stable Diffusion and image generation
- AI model optimization and performance

### 7. [Security Configuration](07-security-configuration.md)
Comprehensive security hardening guide:
- Firewall configuration (UFW)
- SSH hardening
- Fail2Ban intrusion prevention
- User account security
- Docker security
- VPN setup (WireGuard)
- Security auditing tools

### 8. [Remote Access](08-remote-access.md)
Configure remote access to your system:
- SSH setup and configuration
- VNC (Virtual Network Computing)
- RDP (Remote Desktop Protocol)
- NoMachine
- Tailscale VPN
- Port forwarding and DDNS
- Web-based management tools

### 9. [Gaming Setup](09-gaming-setup.md)
Gaming on Linux guide:
- Steam and Proton configuration
- Gaming platforms (Lutris, Heroic)
- Graphics drivers and optimization
- Performance tuning (GameMode, MangoHud)
- Controller setup
- Emulation

### 10. [Video Streaming](10-video-streaming.md)
Streaming and media server setup:
- Video playback and hardware acceleration
- OBS Studio for streaming
- Media servers (Plex, Jellyfin, Emby)
- Video transcoding
- Live streaming with FFmpeg
- IP camera/DVR setup

### 11. [Cool Tools](11-cool-tools.md)
Essential monitoring and management tools:
- Hardware information tools (hardinfo, CPU-X)
- System monitoring (htop, btop, glances, nvtop)
- Temperature monitoring (lm-sensors)
- Disk tools (GSmartControl, iotop, duf)
- Network monitoring (nethogs, iftop)
- Performance benchmarking (sysbench, stress-ng)
- System maintenance (Stacer, BleachBit)
- Power management (powertop, TLP)

### 12. [Troubleshooting](12-troubleshooting.md)
Solutions for common issues:
- Boot problems
- Graphics issues
- Network connectivity
- Audio problems
- Performance issues
- System recovery

### 13. [Home Server Operating Systems](13-home-server-os.md)
**NEW: Transform your AX8 into a powerful home server:**
- CasaOS (beginner-friendly with beautiful UI)
- Cosmos Cloud (security-focused)
- Umbrel (polished experience with crypto features)
- TrueNAS SCALE (enterprise NAS)
- OpenMediaVault (traditional NAS)
- Proxmox VE (virtualization platform)
- YunoHost (all-in-one server with email)
- Comparison and installation guides

### 14. [BookStack Installation](14-bookstack-installation.md)
**NEW: Self-hosted documentation platform:**
- What is BookStack and why use it
- Installation methods (Docker, native, CasaOS)
- Initial configuration and setup
- **Migrating content from this repository to BookStack**
- Automated import scripts
- Maintenance and backup procedures
- Advanced configuration

### 15. [Web Server, Networking & Public Services](15-web-server-networking.md)
**NEW: Complete guide for hosting public services:**
- **Nginx vs Apache comparison** (recommendation: Nginx)
- **UI management tools** (Nginx Proxy Manager, Traefik)
- **Dynamic DNS setup** for Comcast/Surfboard gateway
- **Docker port management** strategies
- **VPN options and cost comparison** (Tailscale, WireGuard, OpenVPN)
- Reverse proxy configuration
- Security best practices for public services
- Complete setup walkthrough with examples

## Quick Navigation

### By Use Case

**Software Developer:**
1. Hardware Specs → BIOS Config → Linux Installation → Peripheral Setup → Development Setup → Security → Remote Access

**AI/ML Developer:**
1. Hardware Specs → BIOS Config → Linux Installation → Development Setup → AI/ML Setup → Security

**Gamer:**
1. Hardware Specs → BIOS Config → Linux Installation → Peripheral Setup → Gaming Setup → Troubleshooting

**Content Creator/Streamer:**
1. Hardware Specs → BIOS Config → Linux Installation → Peripheral Setup → Video Streaming → Remote Access

**System Administrator:**
1. Hardware Specs → BIOS Config → Linux Installation → Security Configuration → Remote Access → Cool Tools

**Home Server:**
1. Hardware Specs → BIOS Config → Linux Installation → Security → Home Server OS → Remote Access → BookStack

**Public Services Host:**
1. Hardware Specs → BIOS Config → Linux Installation → Security → Web Server & Networking → Remote Access

**Documentation Platform:**
1. Hardware Specs → Linux Installation → Home Server OS (CasaOS) → BookStack Installation

## Tips for Using This Documentation

1. **Start with Hardware Specs** to understand your system's capabilities
2. **Follow Linux Installation** for a solid foundation
3. **Apply Security Configuration** early to protect your system
4. **Customize** based on your specific use case
5. **Reference Troubleshooting** when issues arise

## Contributing

Found an error or have a suggestion? Contributions are welcome! Please:
- Open an issue for bug reports
- Submit a pull request for improvements
- Share your experience and tips

## Additional Resources

- [Project README](../README.md) - Main project documentation
- [Web Application](http://localhost:3000) - Browse docs in a web interface
- Official Geekom support: https://www.geekom.com

## Getting Help

If you encounter issues:
1. Check the relevant documentation section
2. Review the Troubleshooting guide
3. Search for similar issues online
4. Ask in Linux communities (Reddit, forums)
5. Open a GitHub issue

## License

This documentation is provided under the MIT License. See the [LICENSE](../LICENSE) file for details.
