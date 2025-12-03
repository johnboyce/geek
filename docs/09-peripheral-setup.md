# Peripheral Setup Guide

This guide provides detailed setup information for the specific peripherals used with your Geekom AX8 mini PC.

## Hardware Overview

### RedThunder K84 Wireless Keyboard and Mouse Combo

**Specifications:**
- Type: 2.4GHz Wireless
- Connection: USB-A receiver (nano)
- Keyboard: 84-key compact layout
- Mouse: Ergonomic design with adjustable DPI (typically 800-2400 DPI)
- Range: Up to 10 meters
- Battery: AA/AAA (check device)
- Power saving: Auto-sleep mode

**Linux Setup:**
1. Insert USB receiver into any available USB port
2. Turn on keyboard and mouse (check power switches)
3. Linux will automatically detect devices (HID standard)
4. No drivers required - plug and play

**Troubleshooting:**
- Not responding: Check batteries and power switches
- Intermittent connection: Move USB receiver away from USB 3.0 ports (can cause interference)
- Keyboard layout: Configure in System Settings → Keyboard
- Mouse sensitivity: Configure in System Settings → Mouse & Touchpad

**Special Features:**
- Function keys (Fn): May require additional configuration
- Multimedia keys: Usually work out of the box
- DPI switching: Hardware buttons on mouse

### SSK 128GB Dual USB C Flash Drive

**Specifications:**
- Model: 2-in-1 Type C + USB A
- Interface: USB 3.2 Gen2
- Capacity: 128GB
- Transfer Speed: Up to 10 Gbps (theoretical)
- Connectors: USB-C and USB-A (both on same drive)
- Solid State: Yes (SSD-based, not traditional flash)

**Linux Compatibility:**
- Fully supported in all modern Linux distributions
- Auto-mounting: Yes
- Hot-plug: Supported

**Formatting Options:**

For Linux-only use:
```bash
# Check device name
lsblk

# Format as ext4 (replace sdX with your device)
sudo mkfs.ext4 -L "SSK_Drive" /dev/sdX1

# Mount
sudo mount /dev/sdX1 /mnt/usb
```

For cross-platform use (Linux, Windows, Mac):
```bash
# Format as exFAT
sudo mkfs.exfat -n "SSK_Drive" /dev/sdX1

# Install exFAT support if needed
sudo apt install exfat-fuse exfat-utils  # Ubuntu/Debian
sudo dnf install exfat-utils fuse-exfat  # Fedora
```

**Performance Tips:**
- Use USB 3.2 port for maximum speed
- USB-C connection typically offers better sustained performance
- Ensure proper cooling during extended write operations
- Regular TRIM support on ext4 and modern filesystems

**Benchmarking:**
```bash
# Install benchmark tools
sudo apt install hdparm fio

# Test read speed
sudo hdparm -Tt /dev/sdX

# Sequential read test
fio --name=seqread --rw=read --bs=1M --size=1G --numjobs=1 --filename=/mnt/usb/test

# Sequential write test
fio --name=seqwrite --rw=write --bs=1M --size=1G --numjobs=1 --filename=/mnt/usb/test

# Random 4K read/write
fio --name=randreadwrite --rw=randrw --bs=4K --size=1G --numjobs=4 --filename=/mnt/usb/test
```

### Acer Nitro KG241Y Sbiip Gaming Monitor

**Specifications:**
- Size: 23.8 inches
- Resolution: 1920 x 1080 (Full HD)
- Panel Type: VA (Vertical Alignment)
- Refresh Rate: 75Hz
- Response Time: 1ms VRB
- Brightness: 250 cd/m²
- Contrast Ratio: 100,000,000:1 (ACM)
- Connections: HDMI 1.4, VGA
- VESA Mount: 100x100mm
- Built-in Speakers: 2W x 2

**Linux Setup:**

The monitor works plug-and-play with Linux. To optimize settings:

```bash
# Check detected display
xrandr

# Set refresh rate to 75Hz
xrandr --output HDMI-1 --mode 1920x1080 --rate 75

# Make permanent by adding to ~/.xprofile or display settings
```

**Gaming Optimization:**
1. Enable FreeSync/Adaptive Sync in monitor OSD
2. Use HDMI 1.4 or better for 75Hz support
3. Set to Game Mode in monitor settings
4. Disable response time overdrive if ghosting occurs
5. Adjust brightness/contrast for your environment

**Color Calibration:**
```bash
# Install color management tools
sudo apt install gnome-color-manager  # GNOME
sudo apt install colord-kde           # KDE

# Create color profile
# System Settings → Color → Add Profile
```

**Monitor Controls:**
- Physical buttons on bottom/side of monitor
- Brightness, Contrast, Color temperature
- Gaming presets (FPS, Racing, RTS)
- Blue light filter

**Troubleshooting:**
- No signal: Check cable connection and input source
- Wrong resolution: Use xrandr or display settings to set 1920x1080
- Low refresh rate: Ensure using HDMI (not VGA) and set to 75Hz
- No sound: Configure audio output in sound settings (HDMI audio)

## Full System Compatibility Matrix

| Component | Linux Compatibility | Driver Required | Notes |
|-----------|-------------------|-----------------|-------|
| RedThunder K84 Keyboard | ✅ Excellent | No | Plug and play, HID standard |
| RedThunder Mouse | ✅ Excellent | No | All buttons work, DPI adjustable |
| SSK USB-C Flash Drive | ✅ Excellent | No | Full USB 3.2 Gen2 support |
| Acer Nitro Monitor | ✅ Excellent | No | 75Hz supported, FreeSync works |

## Quick Setup Commands

### Check USB Devices
```bash
# List all USB devices
lsusb

# Monitor USB events (useful for troubleshooting)
sudo dmesg -w | grep -i usb

# Check mounted drives
df -h
mount | grep /dev/sd
```

### Display Information
```bash
# Check connected displays
xrandr

# Detailed display info
xrandr --verbose

# Check refresh rate
xrandr | grep '*'

# Test monitor capabilities
sudo apt install edid-decode
sudo get-edid | edid-decode
```

### Keyboard/Mouse Testing
```bash
# Test keyboard input
xev

# Check input devices
xinput list

# Monitor all input events
sudo evtest
```

## Performance Benchmarks

### USB Drive Performance

Expected performance for SSK USB 3.2 Gen2 drive:
- Sequential Read: 400-450 MB/s
- Sequential Write: 350-400 MB/s
- Random 4K Read: 15-25 MB/s
- Random 4K Write: 20-35 MB/s

To test your drive:
```bash
# Install testing tools
sudo apt install fio hdparm

# Quick read test
sudo hdparm -Tt /dev/sdX

# Detailed test with fio
fio --name=benchmark --rw=readwrite --bs=4K --size=1G --filename=/mnt/usb/testfile
```

### Monitor Performance

The Acer Nitro supports:
- Native 1920x1080 @ 75Hz
- Response time optimized for gaming (1ms VRB)
- FreeSync compatible for tear-free gaming

To verify:
```bash
# Check current refresh rate
xrandr | grep '*'

# Should show: 1920x1080  75.00*+
```

## Maintenance Tips

### Keyboard and Mouse
- Replace batteries every 3-6 months (depending on usage)
- Keep USB receiver away from sources of interference
- Clean keyboard with compressed air
- Use mousepad for better tracking

### USB Drive
- Safely eject before removing: `sudo umount /dev/sdX1`
- Regular file system checks: `sudo fsck.ext4 /dev/sdX1`
- Maintain at least 10% free space for optimal performance
- Backup important data regularly

### Monitor
- Clean screen with microfiber cloth (no liquids on screen)
- Adjust brightness to reduce eye strain
- Use monitor's power saving features
- Keep ventilation clear

## Advanced Configuration

### Custom Keyboard Mapping
```bash
# Install key mapping tool
sudo apt install xbindkeys xbindkeys-config

# Configure custom key bindings
xbindkeys-config
```

### USB Drive Optimization
```bash
# Enable TRIM on ext4 filesystem
# Add 'discard' option to /etc/fstab
UUID=xxxx /mnt/usb ext4 defaults,discard 0 2

# Or run TRIM manually
sudo fstrim -v /mnt/usb
```

### Monitor Scaling
```bash
# For HiDPI displays or small text, adjust scaling
# GNOME
gsettings set org.gnome.desktop.interface scaling-factor 1.25

# KDE
# System Settings → Display → Scale Display
```

## Troubleshooting Common Issues

### Keyboard/Mouse Lag
1. Move USB receiver to a different port (avoid USB 3.0 if possible)
2. Replace batteries
3. Check for wireless interference (WiFi routers, other devices)
4. Try disabling USB autosuspend:
```bash
# Disable USB autosuspend for specific device
echo 'on' | sudo tee /sys/bus/usb/devices/*/power/control
```

### USB Drive Not Recognized
1. Try different USB port (test both USB-C and USB-A connectors)
2. Check dmesg for errors: `dmesg | tail -50`
3. Try manual mounting:
```bash
sudo mkdir -p /mnt/usb
sudo mount /dev/sdX1 /mnt/usb
```

### Monitor Display Issues
1. Check cable connection (ensure HDMI is fully inserted)
2. Try different HDMI cable
3. Reset monitor to factory defaults
4. Force resolution:
```bash
xrandr --output HDMI-1 --mode 1920x1080 --rate 75
```

## Additional Resources

- RedThunder support: Check product manual for specifications
- SSK support: https://www.sskcom.com/
- Acer support: https://www.acer.com/support
- Linux USB documentation: https://www.kernel.org/doc/html/latest/driver-api/usb/
- Display configuration: https://wiki.archlinux.org/title/Xrandr

## Quick Reference Card

### Common Commands
```bash
# List USB devices
lsusb

# Check mounted drives
df -h

# Display info
xrandr

# Test keyboard/mouse
xev

# USB performance test
sudo hdparm -Tt /dev/sdX

# Monitor refresh rate
xrandr | grep '*'
```

### Device Paths
- Keyboard/Mouse: Usually `/dev/input/event*`
- USB Drive: Usually `/dev/sdX` or `/dev/nvme0n1`
- Monitor: Usually `HDMI-1`, `HDMI-2`, or `DisplayPort-1`

This guide ensures all your peripherals work optimally with your Geekom AX8 Linux system.
