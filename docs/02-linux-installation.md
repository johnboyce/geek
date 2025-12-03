# Linux Installation Guide for Geekom AX8

## Quick Start for MacBook Pro M3 Users

If you're using a MacBook Pro M3 to create the bootable USB for your Geekom AX8:

1. **Download Ubuntu 24.04 LTS ISO**: https://ubuntu.com/download/desktop
2. **Download Balena Etcher**: https://etcher.balena.io/ (ARM64 version for M3)
3. **Connect SSK USB-C drive** to your MacBook M3
4. **Flash ISO** using Balena Etcher (easiest method)
5. **Eject and insert** into Geekom AX8
6. **Boot from USB** (press F7 or F12 during AX8 startup)

👉 See detailed instructions in the **USB Installation Guide** section below.

## Recommended Linux Distributions

### For Development
1. **Ubuntu 24.04 LTS (Recommended)**
   - Long-term support until 2029
   - Excellent hardware compatibility
   - Large software repository
   - Strong community support

2. **Fedora Workstation 40+**
   - Latest software packages
   - Excellent AMD driver support
   - Good for developers wanting cutting edge

3. **Pop!_OS 22.04 LTS**
   - Ubuntu-based with custom improvements
   - Excellent NVIDIA/AMD support
   - Developer-friendly out of the box

### For Gaming
1. **Nobara Linux**
   - Gaming-optimized Fedora spin
   - Pre-configured for gaming
   - Excellent AMD GPU support

2. **Garuda Linux**
   - Arch-based, gaming-focused
   - Performance optimizations included
   - Beautiful UI

## Pre-Installation Checklist

- [ ] Download Linux ISO from official source
- [ ] Verify ISO checksum
- [ ] Create bootable USB drive (see USB Installation Guide below)
- [ ] Backup any important data
- [ ] Check BIOS/UEFI settings

## USB Installation Guide

### Prerequisites
- Linux distribution ISO file (downloaded from official source)
- USB flash drive (8GB minimum, 16GB+ recommended)
- SSK 128GB USB-C drive works perfectly for this purpose
- Current operating system to create bootable USB

### Method 1: Using Balena Etcher (Recommended for MacBook M3)

**Recommended for: MacBook Pro M3 users and beginners**

This is the easiest and most reliable method for creating a bootable USB on macOS, including Apple Silicon Macs like the M3.

1. **Download Balena Etcher for macOS**
   - Visit: https://etcher.balena.io/
   - Download the macOS version (Apple Silicon/ARM64 version for M3)
   - Open the downloaded DMG file
   - Drag Balena Etcher to Applications folder
   - **Note**: M3 Macs may show a security warning - go to System Settings → Privacy & Security to allow

2. **Prepare the USB Drive**
   - Connect your SSK 128GB USB-C drive to your MacBook Pro M3
   - The USB-C connector works perfectly with M3's Thunderbolt/USB-C ports
   - **Warning**: All data on the drive will be erased
   - Back up any important files first

3. **Create Bootable USB on MacBook M3**
   - Launch Balena Etcher from Applications
   - Click "Flash from file" and select your Linux ISO (e.g., Ubuntu 24.04)
   - Click "Select target" and choose your SSK USB-C drive
   - **Important**: Make sure you select the correct drive to avoid data loss
   - Click "Flash!" and enter your Mac password when prompted
   - Wait for completion (3-10 minutes depending on ISO size)
   - Etcher will verify the write automatically
   - You'll see "Flash Complete!" when done

4. **Eject and Transfer to Geekom AX8**
   - Click "Eject" in Balena Etcher or use Finder to eject the drive
   - Safely remove the USB-C drive from your MacBook M3
   - Insert it into your Geekom AX8 (USB-C or USB-A port)
   - Power on the AX8 and press the boot menu key (F7 or F12)
   - Select the USB drive from the boot menu to begin installation

**Troubleshooting on MacBook M3:**
- If Etcher won't open: Right-click → Open, then click "Open" in the dialog
- If the drive doesn't appear: Try reformatting it first using Disk Utility (Format: MS-DOS FAT32)
- Permission errors: Make sure to enter your Mac admin password when prompted

### Method 2: Using Rufus (Windows Only)

1. **Download Rufus**
   - Visit: https://rufus.ie/
   - Download the portable version (no installation needed)

2. **Create Bootable USB**
   - Run Rufus (may require administrator privileges)
   - Select your USB drive under "Device"
   - Click "SELECT" and choose your Linux ISO
   - Partition scheme: GPT (for UEFI)
   - File system: FAT32 (for compatibility)
   - Click "START"
   - If prompted, select "Write in ISO Image mode" (recommended)
   - Wait for completion (3-10 minutes)

### Method 3: Using dd Command (Advanced - MacBook M3 Terminal Method)

**Recommended for: Advanced users comfortable with Terminal on macOS**

This method works perfectly on MacBook Pro M3 and gives you more control.

1. **Open Terminal on MacBook M3**
   - Press Cmd + Space and type "Terminal"
   - Or find it in Applications → Utilities → Terminal

2. **Identify USB Drive**
   ```bash
   diskutil list
   ```
   - Look for your SSK USB-C drive (usually /dev/disk2 or /dev/disk3)
   - Note the identifier (e.g., disk2)
   - **CRITICAL**: Double-check the disk number - wrong selection will erase that disk!
   - Your Mac's internal drive is usually disk0 - DO NOT select it!

3. **Unmount the Drive (Don't Eject)**
   ```bash
   diskutil unmountDisk /dev/diskX
   ```
   - Replace diskX with your drive identifier (e.g., disk2)
   - This unmounts but keeps the device accessible

4. **Write ISO to USB on MacBook M3**
   ```bash
   sudo dd if=~/Downloads/ubuntu-24.04-desktop-amd64.iso of=/dev/rdiskX bs=1m
   ```
   - Replace `diskX` with your actual device (e.g., disk2)
   - Note the 'r' prefix (rdisk) - this is faster on macOS
   - Enter your Mac password when prompted
   - This will take 5-15 minutes with NO progress indicator
   - **Be patient** - the M3 will show no output until complete

5. **Verify and Eject**
   ```bash
   # When dd completes, sync and eject
   sudo sync
   diskutil eject /dev/diskX
   ```

**MacBook M3 Specific Tips:**
- Use `Ctrl + T` during dd to see progress (macOS feature)
- The M3's fast USB-C ports can write at 400+ MB/s to the SSK drive
- Expected time: 3-5 minutes for most ISOs on M3
- If you see "Resource busy", make sure disk is unmounted, not ejected

**Alternative with progress indicator:**
```bash
# Install pv (pipe viewer) for progress
brew install pv

# Use pv to show progress
sudo dd if=~/Downloads/ubuntu-24.04-desktop-amd64.iso | pv | sudo dd of=/dev/rdiskX bs=1m
```

### Method 4: Using Ventoy (Advanced - Multi-ISO Support)

**Recommended for: Users who want to try multiple distributions**

1. **Download Ventoy**
   - Visit: https://www.ventoy.net/
   - Download appropriate version for your OS

2. **Install Ventoy to USB**
   - Run Ventoy installer
   - Select your USB drive
   - Click "Install" (this formats the drive)
   - This creates a regular FAT32 partition

3. **Add ISO Files**
   - Simply copy ISO files to the USB drive
   - No need to "flash" or "burn" them
   - Can store multiple Linux distributions
   - Boot menu will show all available ISOs

4. **Boot from Ventoy**
   - Insert USB into Geekom AX8
   - Boot from USB (F7 or F12)
   - Select desired ISO from Ventoy menu

## BIOS/UEFI Configuration

### Accessing BIOS
1. Power on the system
2. Press **Delete** or **F2** repeatedly during boot
3. Navigate using arrow keys

### Recommended BIOS Settings
- **Secure Boot**: Can be enabled (most modern distros support it)
- **Boot Mode**: UEFI (not Legacy/CSM)
- **Virtualization**: Enabled (AMD-V/SVM)
- **IOMMU**: Enabled (for VM passthrough)
- **Fast Boot**: Disabled during installation
- **Boot Order**: USB first for installation

## Installation Steps

### 1. Boot from USB
```
1. Insert USB drive
2. Restart computer
3. Press F7 or F12 for boot menu
4. Select USB drive
5. Choose "Install Ubuntu" (or your distro)
```

### 2. Installation Process

#### Ubuntu Installation
```
1. Select language
2. Choose keyboard layout
3. Select "Normal installation"
4. Check "Install third-party software" (for WiFi/GPU drivers)
5. Installation type:
   - "Erase disk and install Ubuntu" (simplest)
   - OR "Something else" (for custom partitioning)
6. Set timezone
7. Create user account
8. Wait for installation to complete
9. Restart
10. Remove USB drive
```

### 3. Recommended Partitioning Scheme

For software development and flexibility:

```
/boot/efi - 512MB - FAT32 - EFI System Partition
/boot     - 1GB   - ext4  - Boot partition
/         - 100GB - ext4  - Root partition
/home     - 200GB - ext4  - User data
swap      - 32GB  - swap  - Swap partition (or use swapfile)
/var      - 50GB  - ext4  - Variable data, logs, containers
```

Remaining space can be left for additional partitions or future use.

### 4. First Boot Configuration

After installation and reboot:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential git curl wget vim

# Check kernel version (should be 6.5+ for best AX8 support)
uname -r

# Verify AMD GPU detection
lspci | grep VGA
```

## Post-Installation

### Enable Additional Repositories
```bash
# Enable universe and multiverse repositories (Ubuntu)
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt update
```

### Install Latest AMD Drivers
```bash
# For Ubuntu 24.04+, drivers are usually included
# If needed, install from repository:
sudo apt install -y mesa-vulkan-drivers mesa-utils vulkan-tools

# Verify Vulkan support
vulkaninfo --summary
```

### Update Firmware
```bash
# Install fwupd for firmware updates
sudo apt install fwupd
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

## Troubleshooting

### WiFi Not Working
```bash
# Check WiFi adapter
lspci | grep -i wireless

# Install additional firmware if needed
sudo apt install linux-firmware
sudo reboot
```

### Display Issues
```bash
# Try different kernel parameters in GRUB:
# Edit /etc/default/grub and add to GRUB_CMDLINE_LINUX_DEFAULT:
# amdgpu.dc=1 amdgpu.ppfeaturemask=0xffffffff

sudo update-grub
sudo reboot
```

### Boot Issues
- Use "nomodeset" kernel parameter temporarily
- Update to latest kernel after installation
- Check secure boot is properly configured
