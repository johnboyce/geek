# BIOS Configuration and Updates

## Overview

The Geekom AX8 uses a modern UEFI BIOS that provides extensive configuration options for optimizing your mini PC's performance, compatibility, and security. This guide covers accessing the BIOS, key settings for Linux, updating the BIOS firmware, and troubleshooting common issues.

## Accessing the BIOS

### During System Boot

**Method 1: Delete Key**
1. Power on or restart your Geekom AX8
2. Immediately press the `Delete` key repeatedly
3. Continue pressing until the BIOS screen appears
4. Typical window: First 2-3 seconds after power on

**Method 2: F2 Key**
1. Power on or restart your system
2. Press `F2` repeatedly during boot
3. Some BIOS versions respond better to this key

**Method 3: Boot Menu**
1. Press `F7` during boot to access the boot menu
2. Select "Enter Setup" or similar option
3. Useful if you need to choose boot device first

### From Within Linux

You can also schedule a BIOS entry on next boot:
```bash
# Reboot directly into BIOS/UEFI setup
sudo systemctl reboot --firmware-setup
```

## BIOS Interface Navigation

### Basic Controls

- **Arrow Keys**: Navigate between options
- **Enter**: Select/modify options
- **+/- Keys**: Change values
- **F1**: Help (context-sensitive)
- **F7**: Load optimized defaults
- **F10**: Save changes and exit
- **ESC**: Exit without saving or go back

### Main BIOS Sections

1. **Main**: Basic system information and time/date
2. **Advanced**: CPU, chipset, storage, and USB configuration
3. **Security**: Passwords, Secure Boot, TPM settings
4. **Boot**: Boot order and priority
5. **Exit**: Save/discard changes and exit options

## Essential BIOS Settings for Linux

### Boot Configuration

#### Secure Boot Settings
For maximum Linux compatibility, Secure Boot may need adjustment:

```
Security → Secure Boot → Secure Boot Control
  Recommended: Disabled (for most Linux distros)
  Alternative: Enabled (Ubuntu/Fedora with signed bootloaders)
```

**Note**: If keeping Secure Boot enabled:
- Use signed bootloaders (most major distros support this)
- Enroll custom keys if using custom kernels
- May be required for some corporate environments

#### Boot Mode
```
Boot → Boot Mode
  Recommended: UEFI Only
  Legacy/CSM: Disable (not needed for modern Linux)
```

#### Fast Boot
```
Boot → Fast Boot
  Recommended: Disabled
  Reason: Ensures all hardware initializes properly for Linux
```

#### Boot Order
```
Boot → Boot Priority
  1. Ubuntu (or your Linux bootloader)
  2. USB Storage (for recovery)
  3. Network Boot (if using PXE)
```

### Storage and Performance

#### SATA Mode
```
Advanced → SATA Configuration → SATA Mode
  Recommended: AHCI Mode
  Avoid: RAID Mode (unless specifically needed)
  Reason: Better Linux compatibility and TRIM support
```

#### NVMe Configuration
```
Advanced → NVMe Configuration
  - NVMe Mode: Enabled
  - ASPM (Active State Power Management): Auto or L1
  Note: ASPM can improve power efficiency
```

#### Storage Boot Option
```
Boot → Boot Option Priorities
  Ensure your Linux boot partition is first
  Disable unused storage boot options
```

### CPU and Power Management

#### Processor Settings
```
Advanced → CPU Configuration
  - Intel/AMD Virtualization: Enabled (for VMs/containers)
  - Hyper-Threading/SMT: Enabled (utilize all threads)
  - CPU Power Management: Enabled
  - Turbo Boost: Enabled (maximum performance)
```

#### Power Management
```
Advanced → ACPI Settings
  - Enable ACPI Auto Configuration: Yes
  - ACPI Sleep State: S3 (Suspend to RAM)
  Alternative S0ix: Modern Sleep (if supported)
```

**Power Profile Options:**
- **Quiet/Silent**: Lower fan speeds, reduced power (35W TDP)
- **Balanced**: Good mix of performance and efficiency (45W TDP)
- **Performance**: Maximum performance (54W TDP)
- **Auto**: System manages based on load

### Graphics Configuration

#### Primary Display
```
Advanced → Graphics Configuration
  - Primary Display: Auto or IGFX (Integrated Graphics)
  - UMA Frame Buffer Size: Auto or 2GB
  Note: More VRAM for graphics-intensive tasks
```

#### Display Outputs
```
Advanced → Chipset Configuration
  - HDMI/DisplayPort: All Enabled
  - Multi-Monitor: Enabled
```

### USB and Peripheral Configuration

#### USB Settings
```
Advanced → USB Configuration
  - USB 3.0/3.2: Enabled
  - USB Legacy Support: Enabled (for USB keyboards in GRUB)
  - XHCI Hand-off: Enabled (for Linux USB management)
```

#### Wake Options
```
Advanced → Power Management
  - USB Wake Support: Enabled (wake from USB devices)
  - Wake on LAN: Enabled (if using remote wake)
  - RTC Wake: Configurable (scheduled wake)
```

### Memory Configuration

#### RAM Settings
```
Advanced → Memory Configuration
  - Memory Frequency: Auto or EXPO/XMP Profile
  - EXPO/XMP: Enabled (if your RAM supports it)
  Note: Enables full DDR5-5600 speed or higher
```

**AMD EXPO (Extended Profiles for Overclocking)**

The Geekom AX8's AMD platform supports EXPO profiles for memory overclocking:

- **What is EXPO?**: AMD's answer to Intel XMP, designed specifically for DDR5 memory
- **Benefits**:
  - One-click memory performance optimization
  - Automatically configures optimal timings, voltages, and frequencies
  - Can achieve DDR5-6000, DDR5-6400, or higher speeds with certified modules
  - Improves system responsiveness and application performance
  - Particularly beneficial for content creation, gaming, and AI workloads

**Enabling EXPO:**
```
Advanced → Memory Configuration → AMD EXPO
  1. Ensure you have EXPO-certified DDR5 memory installed
  2. Set to "Enabled" or select "Profile 1"
  3. Save and exit (F10)
  4. System will reboot and train memory at new settings
  5. If unstable, BIOS will automatically revert to safe defaults
```

**Verification in Linux:**
```bash
# Check current memory speed
sudo dmidecode --type memory | grep -i speed

# Or using lshw
sudo lshw -short -C memory
```

**Troubleshooting:**
- If system is unstable after enabling EXPO, try "Profile 2" or manual tuning
- Ensure adequate cooling, as higher memory speeds generate more heat
- Update BIOS to latest version for best EXPO compatibility
- Some non-certified DDR5 modules may work but are not guaranteed

### Security Settings

#### TPM Configuration
```
Security → TPM Device
  - TPM Support: Enabled
  - TPM State: Enabled
  Note: Required for BitLocker, LUKS encryption
```

#### Secure Boot Keys
```
Security → Secure Boot → Key Management
  - Manage Secure Boot keys
  - Clear/Restore factory keys
  - Install custom keys (for custom kernels)
```

#### Administrator Password
```
Security → Administrator Password
  Recommended: Set a strong password
  Prevents unauthorized BIOS changes
```

## BIOS Update Procedures

### Why Update BIOS?

**Update when:**
- Bug fixes for hardware compatibility
- Security vulnerability patches
- New feature support
- Performance improvements
- Stability issues with current version

**Don't update if:**
- System is working perfectly
- No relevant fixes in changelog
- Risk of power failure during update

### Checking Current BIOS Version

#### From BIOS Interface
```
Main → BIOS Information
  Version: [Your current version]
  Date: [Build date]
```

#### From Linux
```bash
# Check BIOS version
sudo dmidecode -s bios-version

# Detailed BIOS information
sudo dmidecode -t bios

# Alternative using sysfs
cat /sys/class/dmi/id/bios_version
cat /sys/class/dmi/id/bios_date
```

### Downloading BIOS Updates

1. **Visit Geekom Support Site**
   - URL: https://www.geekom.com/support/
   - Navigate to AX8 product page
   - Check "BIOS Updates" or "Downloads" section

2. **Verify Update Details**
   - Read changelog carefully
   - Check version number
   - Note any special instructions
   - Verify file checksum/signature if provided

3. **Prepare USB Drive**
   ```bash
   # Format USB drive as FAT32
   sudo mkfs.vfat -F 32 -n "BIOS_UPDATE" /dev/sdX1
   
   # Mount and copy BIOS file
   sudo mount /dev/sdX1 /mnt
   sudo cp GEEKOM_AX8_BIOS_vXXX.bin /mnt/
   sudo umount /mnt
   ```

### BIOS Update Methods

#### Method 1: EZ Flash Utility (Recommended)

**From BIOS:**
1. Enter BIOS setup (Delete/F2 during boot)
2. Navigate to `Advanced → Start Easy Flash` or `Tools → ASUS EZ Flash`
3. Select USB drive containing BIOS file
4. Select the BIOS update file
5. Confirm update
6. **DO NOT POWER OFF** during update
7. System will reboot automatically when complete

**Safety Tips:**
- Ensure stable power (use battery backup/UPS if available)
- Don't interrupt the process
- Takes 5-10 minutes typically
- System may reboot multiple times

#### Method 2: UEFI Boot Method

1. Copy BIOS file to EFI partition:
   ```bash
   # Mount EFI partition
   sudo mount /dev/nvme0n1p1 /mnt
   
   # Copy BIOS file
   sudo cp GEEKOM_AX8_BIOS_vXXX.bin /mnt/
   
   # Unmount
   sudo umount /mnt
   ```

2. Boot to UEFI Shell (if available in boot menu)
3. Navigate to fs0: or appropriate filesystem
4. Run BIOS update utility

#### Method 3: DOS/FreeDOS Method (If Provided)

Some BIOS updates come with DOS-based tools:

1. Create FreeDOS bootable USB:
   ```bash
   # Using UNetbootin or similar
   sudo apt install unetbootin
   unetbootin
   ```

2. Copy BIOS update files to USB
3. Boot from USB
4. Run the BIOS flash utility (usually .bat or .exe)

### After BIOS Update

1. **Load Optimized Defaults**
   ```
   Exit → Load Optimized Defaults
   Save and Exit
   ```

2. **Reconfigure Custom Settings**
   - Review and reapply your Linux-specific settings
   - Check boot order
   - Verify Secure Boot status
   - Retest hardware

3. **Verify Update**
   ```bash
   # Confirm new BIOS version
   sudo dmidecode -s bios-version
   ```

4. **Test System Stability**
   - Boot into Linux
   - Run stress tests if needed
   - Verify all hardware works

## Performance Tuning

### CPU Performance Optimization

#### TDP Configuration
Some BIOS versions allow TDP adjustment:

```
Advanced → CPU Configuration → TDP Control
  Options: 35W (Quiet) / 45W (Balanced) / 54W (Performance)
  
  35W: Quieter, cooler, lower performance
  45W: Good balance for most workloads
  54W: Maximum performance, higher temps
```

#### CPU States and C-States
```
Advanced → CPU Configuration → CPU Power Management
  - C-States: Enabled (power saving)
  - Package C-State: Auto or C7/C8
  - Enhanced C-States: Enabled
  
  Note: Disabling can reduce latency but increases power
```

### Memory Performance

#### Enable XMP Profile
```
Advanced → Memory Configuration → XMP
  Enable XMP Profile 1 (for DDR5-5600)
  
  Before: DDR5-4800
  After: DDR5-5600 (16% faster)
```

#### Memory Timing
```
Advanced → Memory Configuration → DRAM Timing Control
  Usually: Auto (recommended)
  Manual: Only if you know what you're doing
```

### Graphics Performance

#### Integrated GPU Settings
```
Advanced → Graphics Configuration
  - IGFX Multi-Monitor: Enabled
  - DVMT Pre-Allocated: 64MB (default)
  - DVMT Total Gfx Mem: MAX (for better gaming)
```

### Storage Performance

#### Enable SMART
```
Advanced → SATA/NVMe Configuration
  - SMART Monitoring: Enabled
  - TRIM Support: Enabled (for SSD)
```

### Fan and Thermal Management

#### Fan Control
```
Advanced → Hardware Monitor → Fan Control
  Options:
  - Silent: Lower RPM, quieter
  - Standard: Balanced
  - Performance: Higher RPM, better cooling
  - Full Speed: Maximum cooling
```

**Custom Fan Curves** (if available):
- Set temperature thresholds
- Define fan speed percentages
- Create custom profiles for different scenarios

## Overclocking (Advanced Users)

**Warning**: Overclocking can void warranty and damage hardware. Proceed with caution.

### CPU Overclocking

```
Advanced → Overclocking → CPU Settings
  - CPU Core Ratio: Increase carefully (+100-200 MHz)
  - CPU Voltage: May need slight increase
  - Monitor: Temperatures and stability
```

**Safe Limits:**
- Temperature: Keep under 95°C
- Voltage: Don't exceed 1.35V
- Test with: stress-ng, Prime95, or similar

### Memory Overclocking

```
Advanced → Overclocking → Memory Settings
  - DRAM Frequency: Try next higher profile
  - DRAM Voltage: May need 1.35V → 1.40V
  - Test with: memtest86+
```

### Stability Testing

After any overclocking:
```bash
# CPU stress test
stress-ng --cpu 16 --timeout 30m --metrics-brief

# Memory test
sudo memtester 8G 3

# Full system stress
sudo apt install stress
stress --cpu 16 --io 4 --vm 2 --vm-bytes 4G --timeout 600s
```

## BIOS Password Management

### Setting BIOS Password

```
Security → Password Settings
  Types:
  1. Administrator Password: Full BIOS access
  2. User Password: Boot system only
  3. HDD Password: Encrypt storage (careful!)
```

**Setting Password:**
1. Select password type
2. Press Enter
3. Type new password
4. Confirm password
5. Save changes (F10)

### Resetting Forgotten Password

**Option 1: CMOS Clear (Hardware)**
1. Power off system completely
2. Unplug power cable
3. Open case (if accessible)
4. Locate CMOS battery
5. Remove battery for 5-10 minutes
6. Reinstall battery
7. Power on - BIOS reset to defaults

**Option 2: Jumper Method**
1. Locate CMOS clear jumper on motherboard
2. Move jumper to clear position
3. Wait 10 seconds
4. Return jumper to normal position
5. Power on

**Note**: Password reset also clears all custom settings

## Troubleshooting BIOS Issues

### BIOS Won't Load

**Symptoms**: Black screen, no BIOS display

**Solutions:**
1. **Try different display output**
   - Switch between HDMI ports
   - Try DisplayPort

2. **Clear CMOS**
   - Remove CMOS battery
   - Wait 5-10 minutes
   - Reinstall and test

3. **Remove peripherals**
   - Disconnect all USB devices
   - Remove external drives
   - Try minimal hardware

### Boot Loop After BIOS Update

**Symptoms**: System keeps restarting

**Solutions:**
1. **Let it complete**
   - May reboot 2-3 times normally
   - Wait 10 minutes before intervening

2. **Clear CMOS**
   - Reset to factory defaults
   - Retry boot

3. **Reflash BIOS**
   - Use BIOS recovery method
   - May require special procedure (check manual)

### Settings Don't Save

**Symptoms**: BIOS resets on every boot

**Causes:**
- Dead CMOS battery
- Corrupted BIOS

**Solutions:**
```bash
# Check CMOS battery voltage (should be ~3V)
# In BIOS: Hardware Monitor → CMOS Battery Voltage

# If low:
1. Replace CR2032 battery (common type)
2. Save settings again
```

### Hardware Not Detected

**Symptoms**: SSD, RAM, or peripherals missing in BIOS

**Solutions:**
1. **Reseat hardware**
   - Power off completely
   - Remove and reinstall component
   - Ensure proper connection

2. **Update BIOS**
   - May fix detection issues
   - Check release notes

3. **Load defaults**
   - F7 in BIOS
   - Restore optimized defaults

### POST Beep Codes

**Understanding beep patterns:**
- 1 short beep: Normal POST, system OK
- 2 short beeps: POST error, check screen
- 3 short beeps: Memory error
- 1 long, 2 short: Graphics error
- Continuous beeping: Power/memory issue

**Actions:**
1. Count beeps carefully
2. Check motherboard manual
3. Reseat indicated component
4. Test with minimal hardware

### BIOS Corruption Recovery

If BIOS becomes corrupted:

1. **BIOS Recovery Mode**
   - Some boards support USB-based recovery
   - Power off system
   - Insert USB with BIOS file named specifically (check manual)
   - Hold specific key combo during power on
   - System should auto-flash BIOS

2. **Contact Support**
   - Geekom support may provide recovery tools
   - May require RMA if hardware flash is needed

## BIOS Best Practices

### Regular Maintenance

✅ **Do:**
- Check for BIOS updates quarterly
- Read changelogs before updating
- Back up important data before BIOS update
- Document your custom settings
- Update only when necessary
- Use UPS during BIOS updates

❌ **Don't:**
- Update BIOS during storms/unstable power
- Update if system is working perfectly
- Interrupt BIOS update process
- Overclock without proper cooling
- Disable security features without understanding implications
- Forget administrator password

### Backup BIOS Settings

**Document Your Settings:**
```bash
# Create settings backup file
cat > ~/bios-settings-backup.txt << 'EOF'
BIOS Version: [version]
Date: [date]

Boot:
- Secure Boot: Disabled
- Boot Mode: UEFI
- Boot Order: NVMe, USB, Network

Advanced:
- Virtualization: Enabled
- SATA Mode: AHCI
- XMP Profile: Enabled

Power:
- TDP: 45W
- Fan: Standard
EOF
```

**Take Photos:**
- Use phone to photograph each BIOS screen
- Store in cloud/backup drive
- Reference when reconfiguring

### Security Hardening

1. **Set Administrator Password**
   - Prevents unauthorized changes
   - Use strong, unique password

2. **Enable Secure Boot** (if compatible)
   - Protects against boot-level malware
   - Ensure Linux distro supports it

3. **Enable TPM**
   - Required for full disk encryption
   - Improves security posture

4. **Disable Unused Ports**
   - Reduce attack surface
   - Disable unused boot options

5. **Review Settings Regularly**
   - Check for unauthorized changes
   - Audit settings quarterly

## References and Resources

### Official Resources
- Geekom AX8 Support: https://www.geekom.com/support/
- User Manual: Check product box or download from website
- BIOS Release Notes: Available with BIOS updates

### Linux BIOS/UEFI Tools
```bash
# Install useful UEFI tools
sudo apt install efibootmgr dmidecode

# View UEFI boot entries
efibootmgr -v

# Change boot order
sudo efibootmgr -o 0001,0002,0003

# Check system information
sudo dmidecode --type bios
sudo dmidecode --type system
```

### Community Resources
- Reddit: r/MiniPCs
- Geekom User Forums
- Ubuntu Forums: UEFI section
- Arch Wiki: UEFI page (excellent technical reference)

## Summary

Proper BIOS configuration is crucial for optimal Linux performance on your Geekom AX8. Key takeaways:

- **Access BIOS**: Use Delete or F2 key during boot
- **Essential Settings**: Disable Secure Boot (or configure properly), use AHCI mode, enable virtualization
- **Update Carefully**: Only when needed, ensure stable power, read changelogs
- **Optimize Performance**: Enable XMP, adjust TDP for your use case, configure fan profiles
- **Security**: Set passwords, enable TPM, use Secure Boot if possible
- **Troubleshooting**: Clear CMOS for most issues, document settings for recovery

With these configurations, your Geekom AX8 will run Linux smoothly and efficiently, whether you're developing, gaming, or running servers.
