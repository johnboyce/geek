# Linux Installation Guide for Mini-PC

## Hardware Compatibility

### Peripherals
- **Keyboard/Mouse**: RedThunder K84 Wireless Keyboard and Mouse Combo
- **Storage**: SSK 128GB Dual USB C Flash Drive (2-in-1 Type C + USB A 3.2 Gen2)
- **Display**: Acer Nitro KG241Y Sbiip 23.8" Full HD (1920 x 1080) VA Gaming Monitor

All peripherals listed are fully compatible with Linux systems.

## Recommended Linux Distributions

### Best Overall: Ubuntu 24.04 LTS
**Recommended for: Most users, beginners, and general use**

- **Pros**: 
  - Excellent hardware support out of the box
  - Large community and extensive documentation
  - Long-term support (5 years of updates)
  - Gaming support with Steam and Proton
  - RedThunder wireless peripherals work plug-and-play
  - Full USB-C and USB 3.2 Gen2 support
  - Native support for 1920x1080 displays
- **Cons**: 
  - Uses more resources than lightweight alternatives
  - Snap packages can be slower to start
- **Desktop Environment**: GNOME (default), but KDE Plasma also available
- **Download**: https://ubuntu.com/download/desktop

### Best for Gaming: Pop!_OS 22.04 LTS
**Recommended for: Gamers and NVIDIA GPU users**

- **Pros**:
  - Based on Ubuntu with gaming optimizations
  - Excellent NVIDIA driver support out of the box
  - Custom COSMIC desktop with tiling window support
  - Great for high-refresh gaming monitors like the Acer Nitro
  - Steam and Proton pre-configured
- **Cons**:
  - Smaller community than Ubuntu
  - Less frequent updates than rolling releases
- **Desktop Environment**: COSMIC (customized GNOME)
- **Download**: https://pop.system76.com/

### Best for Performance: Fedora Workstation 41
**Recommended for: Users wanting latest features and stability**

- **Pros**:
  - Latest software and kernel versions
  - Excellent hardware support including USB-C
  - Wayland by default (better for modern displays)
  - Red Hat backing ensures quality
  - Good gaming support with Flatpak
- **Cons**:
  - Shorter support cycle (13 months)
  - Requires more frequent upgrades
- **Desktop Environment**: GNOME (default)
- **Download**: https://fedoraproject.org/workstation/

### Best Lightweight: Linux Mint 21.3 "Virginia"
**Recommended for: Older hardware or users preferring traditional desktop**

- **Pros**:
  - Very lightweight and fast
  - Traditional desktop layout (Windows-like)
  - Based on Ubuntu LTS (reliable)
  - Excellent for beginners
  - Low resource usage
- **Cons**:
  - More conservative software versions
  - Not as cutting-edge as other options
- **Desktop Environment**: Cinnamon (default), MATE, or Xfce
- **Download**: https://linuxmint.com/download.php

### Best Rolling Release: Manjaro Linux
**Recommended for: Users wanting latest software without Arch complexity**

- **Pros**:
  - Rolling release (always up-to-date)
  - Based on Arch Linux but user-friendly
  - Multiple desktop environment options
  - Great hardware detection
  - AUR (Arch User Repository) access
- **Cons**:
  - Occasional stability issues with updates
  - Requires more maintenance knowledge
- **Desktop Environment**: KDE Plasma, GNOME, or Xfce
- **Download**: https://manjaro.org/download/

## USB Installation Guide

### Prerequisites
- SSK 128GB Dual USB C Flash Drive
- Downloaded Linux ISO file (2-4 GB)
- Access to a computer (Windows, Mac, or Linux)

### Method 1: Using Balena Etcher (Easiest - All Platforms)

1. **Download Balena Etcher**
   - Visit: https://etcher.balena.io/
   - Download for your current operating system
   - Install the application

2. **Prepare the USB Drive**
   - Connect your SSK USB-C flash drive
   - **Warning**: All data on the drive will be erased
   - Back up any important files first

3. **Create Bootable USB**
   - Launch Balena Etcher
   - Click "Flash from file" and select your Linux ISO
   - Click "Select target" and choose your SSK USB drive
   - Click "Flash!" and wait for completion (3-10 minutes)
   - Etcher will verify the write automatically

4. **Boot from USB**
   - Safely eject the USB drive
   - Insert it into your Mini-PC
   - Power on and press the boot menu key (usually F12, F2, ESC, or DEL)
   - Select the USB drive from the boot menu
   - If using USB-C port, ensure your Mini-PC BIOS supports USB-C boot

### Method 2: Using Rufus (Windows Only)

1. **Download Rufus**
   - Visit: https://rufus.ie/
   - Download the portable version (no installation needed)

2. **Create Bootable USB**
   - Run Rufus (may require administrator privileges)
   - Select your SSK USB drive under "Device"
   - Click "SELECT" and choose your Linux ISO
   - Partition scheme: GPT (for UEFI) or MBR (for Legacy BIOS)
   - File system: FAT32 (for compatibility)
   - Click "START"
   - If prompted, select "Write in ISO Image mode" (recommended)
   - Wait for completion (3-10 minutes)

### Method 3: Using dd Command (Linux/Mac)

1. **Identify USB Drive**
   ```bash
   # Linux
   lsblk
   # Mac
   diskutil list
   ```
   - Note the device name (e.g., /dev/sdb or /dev/disk2)
   - **Be very careful**: selecting wrong device will erase it

2. **Unmount the Drive**
   ```bash
   # Linux
   sudo umount /dev/sdX*
   # Mac
   diskutil unmountDisk /dev/diskX
   ```

3. **Write ISO to USB**
   ```bash
   # Linux
   sudo dd if=/path/to/linux.iso of=/dev/sdX bs=4M status=progress && sync
   # Mac
   sudo dd if=/path/to/linux.iso of=/dev/rdiskX bs=1m
   ```
   - Replace `/dev/sdX` with your actual device
   - This will take 5-15 minutes
   - Wait for the command to complete

### Method 4: Using Ventoy (Advanced - Multi-ISO Support)

1. **Download Ventoy**
   - Visit: https://www.ventoy.net/
   - Download appropriate version for your OS

2. **Install Ventoy to USB**
   - Run Ventoy installer
   - Select your SSK USB drive
   - Click "Install" (this formats the drive)
   - This creates a regular FAT32 partition

3. **Add ISO Files**
   - Simply copy ISO files to the USB drive
   - No need to "flash" or "burn" them
   - Can store multiple Linux distributions
   - Boot menu will show all available ISOs

4. **Boot from Ventoy**
   - Insert USB into Mini-PC
   - Boot from USB
   - Select desired ISO from Ventoy menu

## Installation Process

### BIOS/UEFI Settings

Before installing, configure your Mini-PC BIOS:

1. **Access BIOS**
   - Power on Mini-PC
   - Press BIOS key repeatedly (usually F2, DEL, or F12)
   - Common keys by manufacturer:
     - Intel NUC: F2
     - ASUS: DEL or F2
     - HP: ESC or F10
     - Lenovo: F1 or F2

2. **Recommended Settings**
   - **Boot Mode**: UEFI (disable Legacy/CSM for modern systems)
   - **Secure Boot**: Disable (can enable after installation with most distros)
   - **Fast Boot**: Disable (for better compatibility)
   - **USB Boot**: Enable
   - **Boot Order**: Set USB as first boot device (or use boot menu)

3. **Save and Exit**
   - Save changes (usually F10)
   - Insert USB drive if not already connected
   - System will reboot from USB

### Basic Installation Steps

1. **Boot from USB**
   - Select "Try or Install" option
   - Most distributions allow testing before installing

2. **Connect to Internet** (Optional but recommended)
   - Connect Ethernet cable, or
   - Use RedThunder wireless mouse to connect to WiFi
   - This enables downloading updates during installation

3. **Start Installation**
   - Double-click "Install" icon on desktop, or
   - Select "Install" from boot menu

4. **Choose Language and Keyboard**
   - Select your preferred language
   - Keyboard layout will auto-detect (test with RedThunder keyboard)

5. **Installation Type**
   - **Erase disk and install**: For new/dedicated Linux system
   - **Something else/Manual**: For dual-boot or custom partitioning
   - Recommended for most users: Erase disk option

6. **Disk Partitioning** (if manual)
   - Create EFI partition: 512 MB, FAT32
   - Create swap partition: 2-8 GB (optional with 16GB+ RAM)
   - Create root partition: Remaining space, ext4, mount point: /

7. **User Account**
   - Enter your name and username
   - Set a strong password
   - Choose whether to require password on login

8. **Installation**
   - Click "Install Now"
   - Wait 10-30 minutes for installation
   - Do not remove USB drive during installation

9. **Complete Installation**
   - Remove USB drive when prompted
   - Click "Restart Now"
   - System will boot into your new Linux installation

### Post-Installation Setup

1. **Update System**
   ```bash
   # Ubuntu/Debian-based
   sudo apt update && sudo apt upgrade -y
   
   # Fedora
   sudo dnf update -y
   
   # Manjaro/Arch-based
   sudo pacman -Syu
   ```

2. **Install Additional Drivers**
   - Most hardware works automatically
   - For NVIDIA GPUs: Install proprietary drivers
   - Ubuntu: Software & Updates → Additional Drivers
   - Pop!_OS: NVIDIA drivers pre-installed

3. **Configure Display**
   - Display should auto-detect 1920x1080 resolution
   - Adjust refresh rate in Settings → Displays
   - Acer Nitro KG241Y supports up to 165Hz (verify with your model)

4. **Test Peripherals**
   - RedThunder K84 keyboard: Should work immediately
   - RedThunder wireless mouse: Should work immediately
   - If wireless not working: Check USB receiver is properly connected
   - USB-C flash drive: Test both USB-C and USB-A connectors

## Peripheral-Specific Notes

### RedThunder K84 Wireless Keyboard and Mouse Combo

- **Type**: 2.4GHz wireless with USB receiver
- **Linux Compatibility**: Excellent (HID standard)
- **Setup**: Plug and play
- **Battery**: Check if devices are powered on
- **Range**: Up to 10 meters
- **Troubleshooting**:
  - If not working: Re-insert USB receiver
  - Try different USB port
  - Replace batteries if devices are unresponsive
  - Ensure wireless switch is ON

### SSK 128GB Dual USB C Flash Drive

- **Interface**: USB 3.2 Gen2 (up to 10 Gbps)
- **Connectors**: USB-C and USB-A
- **Linux Compatibility**: Excellent
- **File Systems**:
  - FAT32: Compatible with all systems, 4GB file size limit
  - exFAT: Better for large files, requires exfat-utils
  - ext4: Best for Linux-only use
- **Usage**:
  - Auto-mounts in most distributions
  - Find under /media/username/ or /mnt/
  - Safe to use either USB-C or USB-A connector
- **Performance**: 
  - Read: ~400-500 MB/s (theoretical)
  - Write: ~200-300 MB/s (theoretical)
  - Actual speeds depend on Mini-PC USB controller

### Acer Nitro KG241Y Sbiip Gaming Monitor

- **Resolution**: 1920 x 1080 (Full HD)
- **Panel Type**: VA (Vertical Alignment)
- **Refresh Rate**: 165Hz (verify your model)
- **Inputs**: HDMI, DisplayPort
- **Linux Compatibility**: Excellent
- **Setup**:
  - Connect via HDMI or DisplayPort
  - Linux will auto-detect resolution
  - To enable 165Hz: Settings → Displays → Refresh Rate
  - May require X.Org configuration for custom refresh rates
- **Color Calibration**:
  - Most distros include basic color management
  - For advanced calibration: Install displaycal
- **Gaming Performance**:
  - VA panel: Good contrast, slower response than IPS
  - FreeSync support: Works with AMD GPUs on Linux
  - For NVIDIA: G-Sync compatible (may require setup)

## Troubleshooting

### USB Won't Boot

1. **Check Boot Order**: Ensure USB is first in BIOS
2. **Try Different USB Port**: Use USB 2.0 port if USB 3.0 fails
3. **Disable Secure Boot**: In BIOS/UEFI settings
4. **Verify ISO Integrity**: Re-download and re-create USB
5. **USB-C Issues**: Try USB-A connector instead

### Display Not Working

1. **Check Cable Connection**: Ensure monitor is properly connected
2. **Monitor Input**: Select correct input source on monitor
3. **Try Different Port**: Try HDMI if DisplayPort fails, or vice versa
4. **Boot with nomodeset**: Add to kernel parameters if screen is black
5. **Driver Issues**: May need to install proprietary GPU drivers

### Peripherals Not Working

1. **Keyboard/Mouse**:
   - Check batteries
   - Re-insert USB receiver
   - Try different USB port
   - Ensure devices are powered on
2. **USB-C Drive**:
   - Try USB-A connector
   - Check if drive shows in `lsblk` or `fdisk -l`
   - Mount manually if needed

### Wireless Not Working

1. **Check if Detected**: `lspci` or `lsusb` to verify device
2. **Install Firmware**: Some WiFi cards need additional firmware
3. **Enable Device**: `rfkill list` and `rfkill unblock all`
4. **Driver Installation**: May require proprietary drivers

## Additional Resources

- **Ubuntu Help**: https://help.ubuntu.com/
- **Linux Mint Forums**: https://forums.linuxmint.com/
- **Fedora Documentation**: https://docs.fedoraproject.org/
- **Arch Wiki**: https://wiki.archlinux.org/ (excellent for all distros)
- **Pop!_OS Support**: https://support.system76.com/
- **r/linux4noobs**: Reddit community for beginners
- **r/linuxquestions**: Reddit for troubleshooting

## Quick Start Checklist

- [ ] Download Linux distribution ISO
- [ ] Download Balena Etcher or Rufus
- [ ] Back up any important data
- [ ] Create bootable USB with SSK flash drive
- [ ] Configure BIOS settings (disable Secure Boot, enable USB boot)
- [ ] Boot from USB drive
- [ ] Follow installation wizard
- [ ] Remove USB and reboot
- [ ] Update system after installation
- [ ] Test all peripherals (keyboard, mouse, monitor)
- [ ] Install additional software as needed

## Summary

For your specific setup with the RedThunder keyboard/mouse combo, SSK USB-C flash drive, and Acer Nitro gaming monitor, I recommend:

**Best Choice: Ubuntu 24.04 LTS**
- Most user-friendly with excellent hardware support
- All your peripherals will work out of the box
- Large community for support
- Great for both work and gaming

**Alternative for Gaming: Pop!_OS 22.04 LTS**
- Optimized for gaming performance
- Better utilization of the 165Hz gaming monitor
- Same compatibility as Ubuntu

Use **Balena Etcher** to create your bootable USB drive - it's the easiest method and works perfectly with your SSK dual USB-C drive. The entire process from download to fully installed system should take about 1-2 hours.
