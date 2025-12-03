# Cool Tools for System Monitoring and Management

## Overview

This guide covers essential and advanced tools for monitoring, managing, and optimizing your Geekom AX8 system. These tools help you understand your hardware performance, monitor system resources, and troubleshoot issues.

## Hardware Information and Monitoring Tools

### HWiNFO64 Alternative: hardinfo

**hardinfo** is a comprehensive Linux system information and benchmark tool, similar to HWiNFO on Windows.

```bash
# Install hardinfo
sudo apt install -y hardinfo

# Launch GUI
hardinfo

# Generate report
hardinfo -r -f html > ~/system-report.html
```

**Features:**
- Detailed hardware information (CPU, GPU, RAM, storage)
- Real-time sensor monitoring
- System benchmarks
- Network information
- Export reports in various formats

> **Note:** Screenshots of tools in action can be added once installed on your Geekom AX8 system.

### lm-sensors (Temperature Monitoring)

Real-time hardware sensor monitoring from the command line.

```bash
# Install lm-sensors
sudo apt install -y lm-sensors

# Detect sensors (run once)
sudo sensors-detect
# Answer YES to all prompts

# View current temperatures
sensors

# Watch temperatures in real-time
watch -n 2 sensors
```

**Output example:**
```
k10temp-pci-00c3
Adapter: PCI adapter
Tctl:         +45.0°C  
Tccd1:        +38.2°C  

amdgpu-pci-0300
Adapter: PCI adapter
vddgfx:      700.00 mV 
fan1:        1200 RPM
edge:         +42.0°C  
```

### htop (Enhanced Process Viewer)

Interactive process viewer with better UI than standard `top`.

```bash
# Install htop
sudo apt install -y htop

# Launch
htop
```

**Features:**
- Color-coded CPU and memory usage
- Tree view of processes
- Easy sorting and filtering
- Mouse support
- Kill processes interactively

### btop (Modern Resource Monitor)

A beautiful and feature-rich resource monitor with graphs and themes.

```bash
# Install btop
sudo apt install -y btop

# Launch
btop
```

**Features:**
- Gorgeous UI with graphs
- CPU, memory, disk, and network monitoring
- Process management
- Customizable themes
- Mouse support

### glances (Cross-platform System Monitor)

All-in-one system monitoring tool with web interface support.

```bash
# Install glances
sudo apt install -y glances

# Launch in terminal
glances

# Launch with web interface
glances -w
# Access at http://localhost:61208
```

**Features:**
- CPU, memory, disk, network monitoring
- Process list with sorting
- Disk I/O statistics
- Docker container monitoring
- Alert system
- Export to various formats
- RESTful API

### nvtop (GPU Monitor for AMD/NVIDIA)

GPU monitoring tool specifically designed for NVIDIA and AMD GPUs.

```bash
# Install nvtop
sudo apt install -y nvtop

# Launch
nvtop
```

**Features:**
- Real-time GPU usage
- Memory usage tracking
- Process-specific GPU usage
- Multiple GPU support
- Works with AMD Radeon 780M

## System Information Tools

### neofetch (System Info with Style)

Display system information with your distro's logo.

```bash
# Install neofetch
sudo apt install -y neofetch

# Run
neofetch

# Customize
nano ~/.config/neofetch/config.conf
```

### inxi (Comprehensive System Info)

Detailed system information from the command line.

```bash
# Install inxi
sudo apt install -y inxi

# Full system info
inxi -Fxz

# CPU info
inxi -C

# Graphics info
inxi -G

# Audio info
inxi -A

# Network info
inxi -N
```

### CPU-X (CPU-Z Alternative)

GUI tool for detailed CPU information, similar to CPU-Z on Windows.

```bash
# Install CPU-X
sudo apt install -y cpu-x

# Launch
cpu-x
```

**Features:**
- Detailed CPU specifications
- Cache information
- Motherboard details
- Memory information
- Graphics card info
- System tab with OS details

## Disk and Storage Tools

### GSmartControl (S.M.A.R.T. Monitoring)

GUI tool for monitoring disk health using S.M.A.R.T. data.

```bash
# Install GSmartControl
sudo apt install -y gsmartcontrol

# Launch with sudo
sudo gsmartcontrol
```

**Features:**
- Disk health status
- Temperature monitoring
- Error logs
- Self-test capabilities
- Detailed attribute display

### iotop (Disk I/O Monitor)

Monitor disk I/O usage by process.

```bash
# Install iotop
sudo apt install -y iotop

# Launch
sudo iotop
```

### duf (Better df)

Modern disk usage utility with better output than `df`.

```bash
# Install duf
sudo snap install duf

# Run
duf
```

## Network Monitoring Tools

### nethogs (Network Usage by Process)

Monitor network bandwidth usage per process.

```bash
# Install nethogs
sudo apt install -y nethogs

# Launch (requires sudo)
sudo nethogs
```

### iftop (Network Interface Monitor)

Real-time network bandwidth monitoring.

```bash
# Install iftop
sudo apt install -y iftop

# Monitor default interface
sudo iftop

# Monitor specific interface
sudo iftop -i eth0
```

### speedtest-cli (Internet Speed Test)

Command-line tool for testing internet speed.

```bash
# Install speedtest-cli
sudo apt install -y speedtest-cli

# Run speed test
speedtest-cli

# Show results in simple format
speedtest-cli --simple
```

## Performance Benchmarking Tools

### sysbench (System Benchmark)

Multi-threaded benchmark tool for testing CPU, memory, and I/O.

```bash
# Install sysbench
sudo apt install -y sysbench

# CPU benchmark
sysbench cpu --threads=16 --time=30 run

# Memory benchmark
sysbench memory --threads=8 --memory-total-size=10G run

# File I/O benchmark
sysbench fileio --file-total-size=2G prepare
sysbench fileio --file-total-size=2G --file-test-mode=rndrw --time=60 run
sysbench fileio --file-total-size=2G cleanup
```

### stress-ng (Stress Testing)

Comprehensive stress testing tool for CPU, memory, disk, and more.

```bash
# Install stress-ng
sudo apt install -y stress-ng

# CPU stress test (all cores for 60 seconds)
stress-ng --cpu 16 --timeout 60s --metrics-brief

# Memory stress test
stress-ng --vm 4 --vm-bytes 4G --timeout 60s

# Combined stress test
stress-ng --cpu 8 --vm 2 --vm-bytes 2G --timeout 60s
```

## System Maintenance Tools

### stacer (System Optimizer and Monitor)

All-in-one system optimizer with GUI.

```bash
# Install Stacer
sudo apt install -y stacer

# Launch
stacer
```

**Features:**
- System resource monitoring
- Startup applications manager
- Service manager
- Package uninstaller
- System cleaner
- APT repository manager

### BleachBit (System Cleaner)

Free up disk space and maintain privacy.

```bash
# Install BleachBit
sudo apt install -y bleachbit

# Launch
bleachbit
```

**Features:**
- Clean temporary files
- Clear cache
- Remove old logs
- Free disk space
- Shred files securely

## Power Management and Battery Tools

### powertop (Power Consumption Monitor)

Intel's power monitoring and tuning tool.

```bash
# Install powertop
sudo apt install -y powertop

# Launch
sudo powertop

# Generate HTML report
sudo powertop --html=power-report.html
```

### TLP (Advanced Power Management)

Optimize battery life and power consumption.

```bash
# Install TLP
sudo apt install -y tlp tlp-rdw

# Start TLP service
sudo systemctl enable tlp
sudo systemctl start tlp

# Check status
sudo tlp-stat

# Check battery info
sudo tlp-stat -b
```

## Useful Command-Line Utilities

### fzf (Fuzzy Finder)

Powerful command-line fuzzy finder for files, history, and more.

```bash
# Install fzf
sudo apt install -y fzf

# Search files
fzf

# Search command history
history | fzf

# Combine with other commands
vim $(fzf)
```

### ripgrep (Fast Search)

Extremely fast code search tool, better than grep.

```bash
# Install ripgrep
sudo apt install -y ripgrep

# Search for pattern
rg "search_term"

# Search specific file types
rg "search_term" -t py

# Case insensitive
rg -i "search_term"
```

### bat (Better cat)

Syntax-highlighted file viewer with Git integration.

```bash
# Install bat
sudo apt install -y bat

# View file (may need to use batcat on Ubuntu/Debian)
batcat filename.txt

# Create alias if needed
echo 'alias bat=batcat' >> ~/.bashrc
source ~/.bashrc
```

### ncdu (NCurses Disk Usage)

Interactive disk usage analyzer.

```bash
# Install ncdu
sudo apt install -y ncdu

# Analyze current directory
ncdu

# Analyze specific path
ncdu /home
```

## Clipboard Managers

### CopyQ (Advanced Clipboard Manager)

Feature-rich clipboard manager with search and scripting.

```bash
# Install CopyQ
sudo apt install -y copyq

# Launch
copyq
```

**Features:**
- Store unlimited clipboard history
- Search clipboard items
- Edit items before pasting
- Custom keyboard shortcuts
- Scripting support

## Terminal Emulators

### Terminator (Advanced Terminal)

Terminal emulator with split panes and tabs.

```bash
# Install Terminator
sudo apt install -y terminator

# Launch
terminator
```

### Tilix (Tiling Terminal)

Modern terminal with tiling support.

```bash
# Install Tilix
sudo apt install -y tilix

# Launch
tilix
```

## Quick Reference

### Essential Monitoring Commands

```bash
# System overview
htop                  # Interactive process viewer
glances               # All-in-one monitor
btop                  # Modern resource monitor

# Hardware info
sensors               # Temperature monitoring
hardinfo              # Complete hardware info
inxi -Fxz            # Detailed system info

# GPU monitoring
nvtop                 # GPU usage and memory

# Disk monitoring
sudo iotop            # I/O by process
duf                   # Disk usage
sudo gsmartcontrol    # Disk health

# Network monitoring
sudo nethogs          # Bandwidth by process
sudo iftop            # Interface bandwidth
speedtest-cli         # Internet speed test

# Performance testing
sysbench cpu run      # CPU benchmark
stress-ng --cpu 16    # Stress test
```

## Automated Monitoring Setup

### Create a monitoring dashboard script

```bash
# Create monitoring script
cat > ~/monitor.sh << 'EOF'
#!/bin/bash
echo "=== System Monitor ==="
echo
echo "CPU & Memory:"
htop -C --tree | head -20
echo
echo "Temperatures:"
sensors
echo
echo "Disk Usage:"
df -h | grep -v loop
echo
echo "Network:"
ip -s link
EOF

chmod +x ~/monitor.sh
```

### Set up automatic log monitoring

```bash
# Install logwatch for daily reports
sudo apt install -y logwatch

# Configure logwatch
sudo nano /usr/share/logwatch/default.conf/logwatch.conf
# Set Detail level and email
```

## Tips for Using These Tools

1. **Start with basics**: Begin with `htop`, `sensors`, and `htop` before moving to advanced tools
2. **Regular monitoring**: Use tools like `glances` or `btop` daily to understand your system's normal behavior
3. **Benchmark early**: Run benchmarks after setup to have baseline performance data
4. **Create aliases**: Add frequently used commands to your `.bashrc` or `.zshrc`
5. **Combine tools**: Use tools together for comprehensive analysis (e.g., `nvtop` + `htop` + `sensors`)
6. **Document results**: Keep benchmark results and performance data for troubleshooting

## Recommended Tool Combinations

### For Developers
- `htop` or `btop` for process monitoring
- `glances` with web interface for remote monitoring
- `nvtop` for GPU-accelerated development
- `ncdu` for managing disk space

### For System Administrators
- `glances` for comprehensive monitoring
- `iotop` and `nethogs` for I/O and network analysis
- `logwatch` for log analysis
- `powertop` for power optimization

### For Gamers
- `nvtop` for GPU monitoring during gaming
- `MangoHud` (from Gaming Setup guide) for in-game overlay
- `htop` for CPU usage tracking
- `sensors` for temperature monitoring

### For Content Creators
- `nvtop` for rendering workload monitoring
- `iotop` for disk I/O during video editing
- `nethogs` for streaming bandwidth monitoring
- `glances` for overall system health

## Additional Resources

- [htop documentation](https://htop.dev/)
- [btop GitHub](https://github.com/aristocratos/btop)
- [glances documentation](https://nicolargo.github.io/glances/)
- [lm-sensors guide](https://github.com/lm-sensors/lm-sensors)
- [System monitoring best practices](https://www.kernel.org/doc/html/latest/admin-guide/index.html)

## Contributing

Know a cool tool that should be included here? Feel free to contribute by opening a pull request or issue!
