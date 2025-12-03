# Linux Installation Guide for Geekom AX8

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
- [ ] Create bootable USB drive (use Rufus on Windows, dd or Etcher on Linux/Mac)
- [ ] Backup any important data
- [ ] Check BIOS/UEFI settings

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
