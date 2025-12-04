# 🚀 Quick Start: Your Amazing Geekom AX8 Setup Journey!

Welcome to the ULTIMATE guide for getting your Geekom AX8 mini PC up and running! This powerhouse machine is about to become your new favorite piece of tech, and we're here to make the setup process absolutely FANTASTIC! 🎉

## 🌟 Why You're Going to LOVE Your Geekom AX8!

Your AX8 packs an **AMD Ryzen 9 8945HS** with a stunning **16 TOPS AI NPU** and **Radeon 780M graphics** into a tiny, whisper-quiet package! It's perfect for development, gaming, AI/ML workloads, streaming, and even running a complete home server. The possibilities are endless!

---

## 🎯 Choose Your Adventure: Installation Paths

Pick the setup path that matches your goals! Each option is OPTIMIZED for an amazing experience!

### 🏃 Super Quick: "I Just Want It Working NOW!"

**Perfect for: First-time Linux users, people who want results in minutes**

#### ⚡ Recommended: Ubuntu 24.04 LTS + CasaOS

**Cost: 💰 100% FREE!** Both Ubuntu and CasaOS are completely free and open source!

**Why This ROCKS:**
- ✨ **Ubuntu 24.04 LTS** provides rock-solid stability with support until 2029!
- 🎨 **CasaOS** gives you a GORGEOUS web interface for managing everything - no terminal required!
- 🚀 **Setup time: 15-30 minutes** from zero to hero!
- 💪 **Perfect hardware compatibility** - everything just WORKS out of the box!
- 🌈 One-click app installation for Plex, Jellyfin, Nextcloud, and 100+ more!

**Quick Start Steps:**
1. 📦 Create bootable Ubuntu 24.04 USB ([Guide](03-linux-installation.md#usb-installation-guide))
   - **MacBook M3 users:** Use Balena Etcher - it's AMAZING! ([Details](03-linux-installation.md#method-1-using-balena-etcher-recommended-for-macbook-m3))
2. ⚙️ Configure BIOS for optimal performance ([Guide](02-bios-configuration.md))
3. 🎯 Install Ubuntu (25 minutes, super straightforward!)
4. 🎪 Install CasaOS with ONE command: `curl -fsSL https://get.casaos.io | sudo bash`
5. 🎉 **DONE!** Open your browser and start installing apps!

**What You Get:**
- Beautiful web dashboard at `http://your-ax8-ip`
- Instant access to 100+ ready-to-use applications
- File sharing, media streaming, cloud storage - all built in!
- No command-line skills needed (but they're there if you want them!)

---

### 💻 Developer Paradise: "Maximum Power for Coding!"

**Perfect for: Software developers, AI/ML engineers, DevOps professionals**

#### 🔥 Recommended: Ubuntu 24.04 LTS + Full Dev Stack

**Cost: 💰 100% FREE!** All development tools mentioned are free and open source!

**Why This is PHENOMENAL:**
- 🚀 **LTS stability** means no surprise breakages during critical work!
- 🛠️ **Massive software repository** - install ANY development tool instantly!
- 🤖 **Full AI/ML support** - leverage that incredible 16 TOPS NPU!
- 🐳 **Docker-ready** for containerized development!
- 💎 **Perfect for**: Node.js, Python, Go, Rust, Java, databases, and MORE!

**Quick Start Steps:**
1. 📦 Install Ubuntu 24.04 LTS ([Full Guide](03-linux-installation.md))
2. 🔧 Configure your development environment ([Dev Setup Guide](05-development-setup.md))
3. 🤖 Set up AI/ML tools to use the NPU ([AI/ML Guide](06-ai-ml-setup.md))
4. 🔒 Harden security for remote work ([Security Guide](07-security-configuration.md))
5. 🌐 Configure remote access ([Remote Access Guide](08-remote-access.md))

**What You Get:**
- Full-stack development environment ready in ~1 hour
- PyTorch, TensorFlow, ONNX Runtime with AMD ROCm acceleration
- Local LLM support (run Llama 2, Mistral, and more on your NPU!)
- VS Code, IntelliJ, or any IDE you love
- Docker, Kubernetes, databases - everything you need!

**Bonus:** The AX8's AI NPU means you can run AI models LOCALLY without cloud costs! 🎊

---

### 🎮 Gaming Beast: "Let's PLAY!"

**Perfect for: Gamers who want the best Linux gaming experience**

#### 🎯 Recommended: Nobara Linux or Ubuntu 24.04 + Gaming Tweaks

**Cost: 💰 100% FREE!** Linux gaming is completely free - no Xbox Live or PlayStation Plus subscriptions needed!

**Why This DOMINATES:**
- 🔥 **Nobara comes OPTIMIZED for gaming** - no tweaking needed!
- 🎨 **Radeon 780M graphics** handles modern games beautifully!
- 🎮 **Steam + Proton** gives you access to THOUSANDS of Windows games!
- ⚡ **GameMode and MangoHud** maximize every frame!
- 🕹️ **Controller support** out of the box!

**Quick Start Steps:**
1. 🎪 Install Nobara Linux ([Download](https://nobaraproject.org/)) OR Ubuntu + gaming setup
2. 🎮 Follow the gaming setup guide ([Gaming Guide](09-gaming-setup.md))
3. 🚀 Install Steam and enable Proton
4. 🎯 Configure performance optimizations
5. 🎉 **GAME ON!**

**What You Get:**
- Steam, Lutris, Heroic Games Launcher pre-configured
- Excellent frame rates in modern titles
- Full RGB keyboard/mouse support
- Discord, OBS for streaming your victories!

**Pro Tip:** The AX8's efficient AMD architecture means QUIET gaming - no jet engine sounds! 😎

---

### 🏠 Ultimate Home Server: "Host ALL The Things!"

**Perfect for: Self-hosting enthusiasts, privacy advocates, home lab builders**

#### 🌟 Recommended: Ubuntu Server 24.04 + CasaOS or TrueNAS SCALE

**Cost: 💰 100% FREE!** All home server OS options are free and open source!
- **Potential savings:** $100-300/year vs. cloud storage subscriptions!
- **Break even:** Your AX8 pays for itself in saved subscription costs!

**Why This is INCREDIBLE:**
- 🏰 **Full control** of your data - no Big Tech tracking!
- 💰 **Save money** on cloud subscriptions - host it yourself!
- 🔒 **Privacy by design** - your data never leaves your home!
- 🎨 **Multiple options** from beginner-friendly to enterprise-grade!
- 📦 **Unlimited services** - media, files, automation, documents, and MORE!

**Option A: CasaOS (Easiest - HIGHLY Recommended for Beginners!)**

**Cost: 💰 FREE!** Open source and completely free forever!

**Why CasaOS is AMAZING:**
- 😍 **BEAUTIFUL web interface** - seriously, it's gorgeous!
- ⚡ **5-minute setup** - the fastest path to a working home server!
- 🎪 **App marketplace** with one-click installs
- 🌈 **Low resource usage** - leaves plenty for your services!

**Quick Start:**
```bash
# Install Ubuntu Server 24.04
# Then ONE command to install CasaOS:
curl -fsSL https://get.casaos.io | sudo bash
# Open browser to http://your-ax8-ip - DONE! 🎉
```

**Option B: TrueNAS SCALE (For Serious Storage Needs)**

**Cost: 💰 FREE!** Enterprise-grade features at zero cost!

**Why TrueNAS is POWERFUL:**
- 💪 **Enterprise-grade NAS** - used by businesses worldwide!
- 🛡️ **ZFS filesystem** - the BEST data protection available!
- 📦 **Kubernetes support** - run containerized apps at scale!
- 📊 **Advanced features** - snapshots, replication, encryption!

**Perfect for:** Large media libraries, data hoarders, backup enthusiasts

**Full Setup Guides:**
- [Home Server OS Comparison](13-home-server-os.md) - Explore ALL your options!
- [CasaOS Detailed Guide](13-home-server-os.md#1-casaos-easiest---recommended-for-beginners)
- [TrueNAS Setup](13-home-server-os.md#4-truenas-scale)

**Popular Self-Hosted Apps You Can Run (ALL FREE!):**
- 📺 **Plex/Jellyfin** - Your personal Netflix! (vs. Netflix $15.49/mo)
- ☁️ **Nextcloud** - Your personal Dropbox/Google Drive! (vs. Dropbox $11.99/mo)
- 🔐 **Vaultwarden** - Password manager (Bitwarden compatible)! (vs. 1Password $4.99/mo)
- 📚 **BookStack** - Beautiful documentation platform! (vs. Confluence $5-10/user/mo)
- 🏡 **Home Assistant** - Smart home automation! (FREE vs. proprietary hubs $50-200)
- 📥 **qBittorrent** - Download management! (FREE)
- 📖 **Calibre-Web** - eBook library! (FREE)
- 🎵 **Navidrome** - Music streaming server! (vs. Spotify $10.99/mo)

**💰 Potential Annual Savings: $500-1,000+ by self-hosting!**

---

### 🌐 Public Services Host: "Share With The World!"

**Perfect for: Web developers, content creators, public service hosts**

#### 🚀 Recommended: Ubuntu Server 24.04 + Nginx Proxy Manager + Tailscale

**Cost Breakdown:**
- 💰 **Ubuntu Server:** FREE!
- 💰 **Nginx Proxy Manager:** FREE! (open source)
- 💰 **Tailscale VPN:** FREE for personal use (up to 100 devices)!
- 💰 **Let's Encrypt SSL:** FREE! (automatic certificates)
- 💰 **Dynamic DNS (DuckDNS):** FREE!
- 💵 **Optional Domain:** ~$10-15/year (if you want a custom domain)
- **Total: FREE to $15/year!** 🎉

**Why This Setup SHINES:**
- 🌍 **Host websites and services** accessible from anywhere!
- 🔒 **Automatic HTTPS** with Let's Encrypt certificates!
- 🎨 **Nginx Proxy Manager** - beautiful UI for complex routing!
- 🔐 **Secure VPN access** with Tailscale (free for personal use!)
- 🌐 **Dynamic DNS** support for residential internet!

**Quick Start Steps:**
1. 📦 Install Ubuntu Server 24.04
2. 🛡️ Configure security ([Security Guide](07-security-configuration.md))
3. 🌐 Set up Nginx Proxy Manager ([Web Server Guide](15-web-server-networking.md#nginx-proxy-manager-npm---highly-recommended))
4. 🔐 Configure Tailscale VPN ([VPN Comparison](15-web-server-networking.md#vpn-options-and-cost-comparison))
5. 🌍 Set up Dynamic DNS ([DDNS Guide](15-web-server-networking.md#dynamic-dns-setup))
6. 🎉 **Go live with your services!**

**What You Get:**
- Multiple domains/subdomains on one machine
- Automatic SSL certificates (no manual renewal!)
- Web-based management interface
- Secure remote access via VPN
- Docker container routing made EASY!

**Perfect for Hosting:**
- Personal websites and blogs
- API services
- Web applications
- Documentation sites
- Portfolio projects
- And SO much more!

---

### 🤖 AI/ML Workstation: "Unleash The NPU!"

**Perfect for: Data scientists, ML engineers, AI enthusiasts**

#### 💎 Recommended: Ubuntu 24.04 LTS + ROCm + ONNX Runtime

**Cost: 💰 100% FREE!** All tools are open source!
- **Cloud savings:** Run AI models locally = NO API costs!
- **Typical savings:** $20-100+/month vs. OpenAI/Anthropic APIs
- **Break even:** Your AX8 pays for itself FAST if you use AI regularly!

**Why This is CUTTING-EDGE:**
- 🧠 **16 TOPS NPU** - run AI models FAST!
- 🚀 **AMD ROCm support** - GPU acceleration for training!
- 🤖 **Run LLMs locally** - Llama, Mistral, Phi, and more!
- 🎨 **Stable Diffusion** - generate images on YOUR hardware!
- 💰 **Zero cloud costs** - all inference runs locally!

**Quick Start Steps:**
1. 📦 Install Ubuntu 24.04 LTS
2. 🤖 Follow the AI/ML setup guide ([AI/ML Guide](06-ai-ml-setup.md))
3. 🔥 Install PyTorch with ROCm support
4. 🎯 Set up ONNX Runtime for NPU acceleration
5. 🤖 Install Ollama for local LLM inference
6. 🎨 Configure Stable Diffusion
7. 🚀 **Start building amazing AI applications!**

**What You Get:**
- Full Python ML environment (PyTorch, TensorFlow, JAX)
- NPU-accelerated inference for supported models
- GPU acceleration for training and compute
- Jupyter notebooks for interactive development
- Local LLM hosting with Ollama or LM Studio

**Amazing Use Cases:**
- Run ChatGPT-like models entirely offline!
- Generate images without cloud APIs!
- Train models on your own data!
- Experiment with cutting-edge AI research!

---

## 🎯 Quick Comparison Table

| Use Case | Best OS | Cost | Difficulty | Setup Time | Perfect For |
|----------|---------|------|------------|------------|-------------|
| 🏃 **Quick & Easy** | Ubuntu + CasaOS | **FREE** | ⭐ Easy | 20 min | Beginners, home users |
| 💻 **Development** | Ubuntu 24.04 LTS | **FREE** | ⭐⭐ Medium | 1 hour | Professional developers |
| 🎮 **Gaming** | Nobara/Ubuntu | **FREE** | ⭐⭐ Medium | 45 min | Gamers |
| 🏠 **Home Server** | CasaOS or TrueNAS | **FREE** | ⭐-⭐⭐⭐ Varies | 15-60 min | Self-hosters |
| 🌐 **Public Services** | Ubuntu + NPM | **FREE-$15/yr*** | ⭐⭐⭐ Advanced | 2 hours | Web hosting |
| 🤖 **AI/ML** | Ubuntu + ROCm | **FREE** | ⭐⭐⭐ Advanced | 2 hours | Data scientists |

\* *Optional custom domain cost. Can be completely free with DuckDNS subdomain!*

---

## 🔥 Universal Pro Tips (Works for ALL setups!)

### For MacBook M3 Users Creating USB Drives
✨ **Use Balena Etcher** - it's SPECIFICALLY optimized for Apple Silicon and makes creating bootable USBs EFFORTLESS! ([Guide](03-linux-installation.md#method-1-using-balena-etcher-recommended-for-macbook-m3))

### Before Installing ANYTHING
⚙️ **Configure your BIOS first!** Enable AMD EXPO for memory overclocking and set optimal performance settings. This unlocks the AX8's full potential! ([BIOS Guide](02-bios-configuration.md))

### Essential First Steps (After ANY installation)
```bash
# Update everything to the latest versions
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential git curl wget vim

# Check your awesome hardware
neofetch  # or install it: sudo apt install neofetch
```

### Security MUST-DOs
🔒 **Always configure security immediately!** Even on a home network, protect your system:
- Set up UFW firewall
- Configure SSH key authentication
- Install Fail2Ban for intrusion prevention
- Use strong passwords or passphrases

**Full security checklist:** [Security Configuration Guide](07-security-configuration.md)

---

## 💰 Complete Cost Breakdown: What Will You Actually Spend?

One of the BEST things about the Geekom AX8 and Linux? Almost everything is **FREE**! Here's the complete cost picture:

### 🎉 Core Software: 100% FREE

| Component | Cost | Notes |
|-----------|------|-------|
| **Ubuntu 24.04 LTS** | **FREE** | Free forever, supported until 2029 |
| **Fedora/Nobara Linux** | **FREE** | Free and open source |
| **CasaOS** | **FREE** | Beautiful home server interface |
| **TrueNAS SCALE** | **FREE** | Enterprise-grade NAS software |
| **Docker** | **FREE** | Container platform |
| **All Development Tools** | **FREE** | VS Code, Python, Node.js, Go, Rust, etc. |
| **Gaming Software** | **FREE** | Steam, Proton, Lutris, GameMode |
| **AI/ML Tools** | **FREE** | PyTorch, TensorFlow, ROCm, ONNX |
| **Security Tools** | **FREE** | UFW, Fail2Ban, WireGuard |
| **Remote Access** | **FREE** | SSH, VNC, RDP, NoMachine |

**Total Core Software Cost: $0** 🎊

### 🌐 Optional Network Services

| Service | Cost | When You Need It |
|---------|------|------------------|
| **Tailscale VPN** | **FREE** (up to 100 devices) | Secure remote access - HIGHLY recommended! |
| **Tailscale Personal Pro** | $48/year | Need more features than free tier |
| **DuckDNS (Dynamic DNS)** | **FREE** | Free subdomain for home server |
| **Custom Domain Name** | $10-15/year | Want your own domain (example.com) |
| **Cloudflare DNS** | **FREE** | Use with your own domain |
| **ZeroTier VPN** | **FREE** (25 devices) | Alternative to Tailscale |
| **Let's Encrypt SSL** | **FREE** | Automatic HTTPS certificates |

**Typical Network Setup Cost: FREE to $15/year** 🌟

### 💾 Hardware Add-Ons (Optional)

| Item | Approximate Cost | When You Need It |
|------|------------------|------------------|
| **USB Flash Drive** (for installation) | $8-15 | One-time purchase (SSK 128GB recommended) |
| **External Storage** | $50-300+ | Need more storage than internal |
| **UPS (Uninterruptible Power Supply)** | $60-150 | Protect against power outages |
| **Network Switch** | $20-100 | Multiple wired devices |
| **Extra RAM** (if upgrading) | $50-100 | Already has 32GB, rarely needed |

**Most People Need: $0-50** (AX8 comes ready to go!)

### 📊 Real-World Cost Comparison

#### Scenario 1: Basic Home Server (Beginner)
**Setup:** Ubuntu + CasaOS + Tailscale + DuckDNS
- **Initial Cost:** $0 (use existing USB if you have one)
- **Annual Cost:** $0
- **Cloud Alternative Cost:** $100-300/year (Dropbox, Google Drive, etc.)
- **💰 Annual Savings: $100-300!**

#### Scenario 2: Developer Workstation
**Setup:** Ubuntu + Full Dev Stack + AI/ML Tools
- **Initial Cost:** $0
- **Annual Cost:** $0
- **Cloud Alternative Cost:** $240-600/year (GitHub Codespaces, cloud AI APIs)
- **💰 Annual Savings: $240-600!**

#### Scenario 3: Home Server with Custom Domain
**Setup:** Ubuntu + CasaOS/TrueNAS + Custom Domain + Tailscale
- **Initial Cost:** $10-15 (domain name)
- **Annual Cost:** $10-15/year (domain renewal)
- **Cloud Alternative Cost:** $300-600/year (cloud storage + services)
- **💰 Annual Savings: $285-585!**

#### Scenario 4: Public Web Hosting
**Setup:** Ubuntu + Nginx Proxy Manager + Tailscale + Custom Domain
- **Initial Cost:** $10-15 (domain name)
- **Annual Cost:** $10-15/year (domain renewal)
- **Cloud Alternative Cost:** $60-240/year (VPS hosting like DigitalOcean)
- **💰 Annual Savings: $45-225!**

#### Scenario 5: Complete Self-Hosting + AI
**Setup:** Everything! Home server + Dev + AI/ML + Public services
- **Initial Cost:** $10-15 (domain name, optional)
- **Annual Cost:** $10-15/year (domain renewal)
- **Cloud Alternative Cost:** $500-1,500/year (subscriptions + cloud AI + hosting)
- **💰 Annual Savings: $485-1,485!** 🤑

### 🎯 Bottom Line: ROI on Your Geekom AX8

**Geekom AX8 Purchase Price:** ~$550-650 (depending on deal)

**Break-Even Timeline:**
- 🏃 **Basic Home Server:** 2-6 months vs. cloud storage
- 💻 **Developer + AI/ML:** 1-3 months vs. cloud services
- 🏠 **Complete Self-Hosting:** 4-12 months vs. all subscriptions
- 🌐 **Public Services:** 3-10 months vs. VPS hosting

**After Break-Even:** Your AX8 becomes a **money-saving machine** that runs for YEARS! 💎

### 🆓 Services You Can STOP Paying For

Once your AX8 is set up, you can potentially eliminate or reduce:
- ❌ Dropbox/Google Drive: **Save $120-240/year**
- ❌ Netflix (personal media server): **Save $186/year**
- ❌ Spotify (self-hosted music): **Save $132/year**
- ❌ 1Password/LastPass: **Save $36-60/year**
- ❌ VPS/Web Hosting: **Save $60-240/year**
- ❌ OpenAI/Claude API (local AI): **Save $240-1,200/year**
- ❌ Remote desktop services: **Save $100-300/year**

**Total Potential Savings: $874-2,358 per year!** 🎉

---

## 📚 Next Steps: Dive Deeper!

Ready to customize your setup? Check out these FANTASTIC guides:

### Essential Reading (In Order)
1. 📊 [Hardware Specs](01-hardware-specs.md) - Understand your amazing hardware
2. ⚙️ [BIOS Configuration](02-bios-configuration.md) - Optimize before installation
3. 🐧 [Linux Installation](03-linux-installation.md) - Detailed installation walkthrough
4. 🖱️ [Peripheral Setup](04-peripheral-setup.md) - Get your keyboard, mouse, and monitor perfect

### Level Up Your Setup
5. 💻 [Development Setup](05-development-setup.md) - Complete dev environment
6. 🤖 [AI & ML Setup](06-ai-ml-setup.md) - Unleash the NPU!
7. 🔒 [Security Configuration](07-security-configuration.md) - Lock it down
8. 🌐 [Remote Access](08-remote-access.md) - Work from anywhere
9. 🎮 [Gaming Setup](09-gaming-setup.md) - Optimize for gaming
10. 📺 [Video Streaming](10-video-streaming.md) - OBS, media servers, transcoding

### Advanced Features
11. 🛠️ [Cool Tools](11-cool-tools.md) - Monitoring, benchmarking, management
12. 🔧 [Troubleshooting](12-troubleshooting.md) - Fix common issues
13. 🏠 [Home Server OS Options](13-home-server-os.md) - Compare ALL server platforms
14. 📚 [BookStack Installation](14-bookstack-installation.md) - Self-hosted documentation
15. 🌐 [Web Server & Networking](15-web-server-networking.md) - Host public services

---

## 🎊 You're Ready to Begin!

Your Geekom AX8 is an INCREDIBLE machine, and with these guides, you're going to build something AMAZING! Whether you're setting up a development powerhouse, gaming rig, home server, or all of the above - you've got everything you need right here!

### Choose Your Path Above and Let's GO! 🚀

**Questions?** Check the [Troubleshooting Guide](12-troubleshooting.md) or open a GitHub issue!

**Want to contribute?** We'd LOVE your help making this documentation even better!

**Ready to start?** Pick your installation path above and follow the links to the detailed guides!

---

### 💡 Still Not Sure Which Option to Pick?

**Start with Ubuntu 24.04 LTS + CasaOS!** 

Why? Because it gives you:
- ✅ The stability and compatibility of Ubuntu LTS
- ✅ The ease of use of CasaOS
- ✅ The flexibility to add anything else later
- ✅ A working system in under 30 minutes
- ✅ The ability to explore and learn at your own pace

You can ALWAYS add development tools, gaming setup, or advanced features later. Start simple, then customize! 🌟

---

**Happy building, and welcome to the Geekom AX8 community!** 🎉🚀✨
