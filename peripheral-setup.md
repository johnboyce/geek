# Peripheral Setup Guide

This guide provides detailed setup information for the specific peripherals used with your Mini-PC.

## Hardware Overview

### RedThunder K84 Wireless Keyboard and Mouse Combo

![RedThunder K84 Wireless Keyboard and Mouse Combo](https://m.media-amazon.com/images/I/715LTiwaPWL._AC_SL1500_.jpg)

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

![SSK 128GB Dual USB C Flash Drive](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fc1.neweggimages.com%2FProductImage%2FAZS4S2312270ESHIQBC.jpg&f=1&nofb=1&ipt=97b7d2f8868bd71dc44aba282b57e0dbef103ecefe7db4087594c21c85d73cef)

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
1. **FAT32** (Default, Best Compatibility)
   - Works with all operating systems
   - Limitation: 4GB max file size
   - Best for: USB boot drives, file sharing
   ```bash
   sudo mkfs.vfat -F 32 /dev/sdX1
   ```

2. **exFAT** (Cross-platform, Large Files)
   - Works with Windows, Mac, Linux
   - No file size limit
   - Requires exfat-utils on some systems
   ```bash
   # Install exfat support (Ubuntu/Debian)
   sudo apt install exfat-fuse exfat-utils
   
   # Format
   sudo mkfs.exfat /dev/sdX1
   ```

3. **ext4** (Linux Native)
   - Best performance on Linux
   - Not readable on Windows/Mac without additional software
   - Supports all Linux features
   ```bash
   sudo mkfs.ext4 /dev/sdX1
   ```

**Usage Tips:**
- Always safely eject before removing: `sudo eject /dev/sdX`
- Check read/write speed: `sudo hdparm -tT /dev/sdX`
- Monitor health: `sudo smartctl -a /dev/sdX` (requires smartmontools)
- Both USB-C and USB-A work simultaneously (same storage)
- Use USB-C for best performance if your Mini-PC supports it

**Performance Testing:**
```bash
# Install benchmark tools
sudo apt install hdparm

# Test read speed
sudo hdparm -tT /dev/sdX

# Test with dd (write test - be careful!)
dd if=/dev/zero of=/path/to/mount/testfile bs=1M count=1024
```

**Security:**
- Encrypt drive with LUKS:
  ```bash
  sudo cryptsetup luksFormat /dev/sdX1
  sudo cryptsetup open /dev/sdX1 secure_usb
  sudo mkfs.ext4 /dev/mapper/secure_usb
  ```

### Acer Nitro KG241Y Sbiip Gaming Monitor

![Acer Nitro KG241Y Gaming Monitor](https://carrefourbr.vtexassets.com/arquivos/ids/182370079/image-2.jpg?v=638720586149930000)

**Specifications:**
- Size: 23.8 inches
- Resolution: 1920 x 1080 (Full HD)
- Panel Type: VA (Vertical Alignment)
- Refresh Rate: 165Hz (or 144Hz depending on variant)
- Response Time: 1ms VRB (Variable Refresh Rate)
- Brightness: 250 cd/m²
- Contrast Ratio: 100,000,000:1 (dynamic)
- Viewing Angles: 178° H / 178° V
- Inputs: HDMI 2.0, DisplayPort 1.2
- FreeSync: Yes (AMD compatible)
- Built-in Speakers: Yes (2W x 2)

**Linux Setup:**

1. **Physical Connection:**
   - Use DisplayPort for best performance (165Hz)
   - HDMI 2.0 supports up to 144Hz at 1080p
   - Connect power and video cable
   - Select correct input on monitor (press input/source button)

2. **Display Detection:**
   - Linux should auto-detect monitor
   - Resolution: 1920x1080 set automatically
   - Default refresh rate: Usually 60Hz initially

3. **Enable High Refresh Rate:**

   **GNOME (Ubuntu, Fedora):**
   - Settings → Displays
   - Select 165Hz (or 144Hz) from Refresh Rate dropdown
   - Click Apply
   
   **KDE Plasma:**
   - System Settings → Display and Monitor
   - Click on your display
   - Select refresh rate from dropdown
   - Apply changes
   
   **Manual (X11):**
   ```bash
   # Check available modes
   xrandr
   
   # Set refresh rate
   xrandr --output HDMI-1 --mode 1920x1080 --rate 165
   # or
   xrandr --output DP-1 --mode 1920x1080 --rate 165
   ```
   
   **Make Permanent (X11):**
   Create/edit `/etc/X11/xorg.conf.d/10-monitor.conf`:
   ```
   Section "Monitor"
       Identifier "HDMI-1"
       Modeline "1920x1080_165.00"  581.64  1920 2072 2288 2656  1080 1081 1084 1153  -HSync +Vsync
       Option "PreferredMode" "1920x1080_165.00"
   EndSection
   
   Section "Screen"
       Identifier "Screen0"
       Monitor "HDMI-1"
   EndSection
   ```

4. **Enable FreeSync/Adaptive Sync:**
   
   **AMD GPUs:**
   - FreeSync should work automatically
   - Verify: `xrandr --props | grep vrr`
   - Enable if needed: `xrandr --output HDMI-1 --set "vrr_capable" 1`
   
   **NVIDIA GPUs:**
   - Requires NVIDIA driver 435+ and G-Sync compatible support
   - Enable in NVIDIA Settings
   - May need to enable VRR in X configuration

5. **Color Calibration:**
   ```bash
   # Install color management tools
   sudo apt install displaycal colord
   
   # Basic calibration
   displaycal-display-profile-builder
   ```

**Monitor Settings (On-Screen Display):**
- Press buttons on monitor to access menu
- **Brightness**: Adjust to comfort (recommended: 25-50%)
- **Contrast**: Usually best at default (50)
- **Response Time**: Set to "Fast" or "Fastest" for gaming
- **Black Boost**: Adjust for better shadow visibility
- **Blue Light**: Enable to reduce eye strain
- **Game Mode**: Various presets for different game types
- **FreeSync**: Ensure it's enabled in monitor menu

**Gaming Performance Tips:**

1. **Verify Refresh Rate:**
   ```bash
   # Check current refresh rate
   xrandr | grep "*"
   
   # Test with UFO test
   firefox https://www.testufo.com/
   ```

2. **Reduce Input Lag:**
   - Disable compositor (if using X11)
   - Use Game Mode preset on monitor
   - Set Response Time to fastest setting
   - Disable post-processing effects

3. **Screen Tearing Prevention:**
   ```bash
   # For AMD (add to /etc/environment)
   export AMDGPU_TEAR_FREE=1
   
   # For NVIDIA (add to /etc/X11/xorg.conf.d/20-nvidia.conf)
   Option "TearFree" "true"
   ```

**Troubleshooting:**

1. **No Display:**
   - Check power and video cables
   - Verify correct input source selected on monitor
   - Try different video cable
   - Check if monitor power LED is on

2. **Wrong Resolution:**
   - Use display settings to manually select 1920x1080
   - If option missing, may indicate cable or GPU issue
   - Try different port (HDMI vs DisplayPort)

3. **Low Refresh Rate Stuck at 60Hz:**
   - Ensure using DisplayPort or HDMI 2.0 cable
   - Check cable quality (cheap cables may not support high refresh rates)
   - Verify GPU supports required bandwidth
   - May need to manually create custom resolution/refresh rate

4. **FreeSync Not Working:**
   - Enable in both monitor OSD and GPU driver
   - Verify cable supports Adaptive Sync
   - Check with: `xrandr --props | grep vrr`

5. **Color Issues:**
   - Adjust in monitor OSD
   - Use displaycal for calibration
   - Check color space settings (RGB vs YCbCr)

**Optimal Settings for Different Use Cases:**

**Gaming:**
- Refresh Rate: 165Hz
- Response Time: Fastest
- FreeSync: On
- Game Mode: FPS or Racing (depending on game)
- Black Boost: 4-6
- Blue Light: Off

**General Use/Productivity:**
- Refresh Rate: 60-75Hz (saves power)
- Response Time: Normal
- Blue Light: Level 2-3
- Brightness: 25-40%

**Movies/Video:**
- Game Mode: Cinema/Movie
- Black Boost: 0
- Response Time: Normal
- Contrast: 50

## Full System Compatibility Matrix

> **Note**: Compatibility verified as of December 2024. Newer distribution versions should maintain or improve compatibility.

| Component | Ubuntu 24.04+ | Pop!_OS 22.04+ | Fedora 41+ | Linux Mint 21+ | Manjaro |
|-----------|--------------|---------------|-----------|-----------------|---------|
| RedThunder K84 KB/Mouse | ✅ Perfect | ✅ Perfect | ✅ Perfect | ✅ Perfect | ✅ Perfect |
| SSK 128GB USB-C Drive | ✅ Perfect | ✅ Perfect | ✅ Perfect | ✅ Perfect | ✅ Perfect |
| Acer Nitro KG241Y | ✅ Perfect | ✅ Perfect | ✅ Perfect | ✅ Perfect | ✅ Perfect |
| 165Hz Support | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| FreeSync (AMD) | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| G-Sync (NVIDIA) | ⚠️ With Setup | ✅ Pre-configured | ⚠️ With Setup | ⚠️ With Setup | ⚠️ With Setup |

Legend:
- ✅ Perfect: Works out of the box, no configuration needed
- ⚠️ With Setup: Works, but requires some configuration
- ❌ Not Supported: Does not work or requires significant workarounds

## Quick Setup Commands

### Check USB Devices
```bash
# List all USB devices
lsusb

# Monitor USB events
sudo dmesg | grep -i usb

# Check mounted drives
lsblk
df -h
```

### Display Information
```bash
# Check connected displays
xrandr

# Detailed display info
xrandr --verbose

# Check refresh rate
xrandr | grep "*"

# Test monitor capabilities
sudo apt install hwinfo
hwinfo --monitor
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
```bash
# Install testing tools
sudo apt install fio

# Sequential read test
fio --name=seqread --rw=read --bs=1M --size=1G --numjobs=1 --filename=/path/to/usb/testfile

# Sequential write test
fio --name=seqwrite --rw=write --bs=1M --size=1G --numjobs=1 --filename=/path/to/usb/testfile

# Random 4K read/write
fio --name=randtest --rw=randrw --bs=4K --size=1G --numjobs=4 --filename=/path/to/usb/testfile
```

Expected Results for SSK USB 3.2 Gen2:
- Sequential Read: 400-500 MB/s
- Sequential Write: 200-300 MB/s
- Random 4K Read: 20-40 MB/s
- Random 4K Write: 10-30 MB/s

### Monitor Performance
```bash
# Frame rate testing in game
# Use mangohud overlay
sudo apt install mangohud

# Run game with overlay
mangohud game_command

# Or use fps counter
glxgears -info
```

## Additional Tips

### Wireless Interference
- Keep USB receiver away from USB 3.0 ports (they can cause 2.4GHz interference)
- Alternatively, use a short USB extension cable to move receiver away from ports
- Metal cases can reduce wireless range - keep receiver in open area

### USB-C Best Practices
- Use USB-C port for installation USB to take advantage of faster speeds
- Keep USB-C connector clean (compressed air)
- Don't force connector - it should insert smoothly
- USB-C supports reversible insertion (either orientation works)

### Monitor Care
- Clean screen with microfiber cloth
- Avoid touching screen with fingers
- Use monitor's power saving features
- Don't leave static images on screen for extended periods (VA panels can have image retention)
- Adjust brightness to comfortable level (too bright causes eye strain)

## Support Resources

### Hardware Support
- RedThunder: https://www.redthunder.com/ (Limited Linux support resources)
- SSK: Check product page on Amazon/manufacturer site
- Acer Nitro Monitor: https://www.acer.com/support

### Linux Communities
- Hardware Compatibility: https://linux-hardware.org/
- Monitor Setup: https://wiki.archlinux.org/title/Multihead
- USB Troubleshooting: https://wiki.archlinux.org/title/USB_storage_devices
- Gaming on Linux: https://www.reddit.com/r/linux_gaming/

## Maintenance Checklist

### Weekly
- [ ] Clean keyboard and mouse
- [ ] Check battery levels on wireless devices
- [ ] Wipe monitor screen if needed

### Monthly
- [ ] Update system software
- [ ] Check for firmware updates (Mini-PC BIOS, monitor)
- [ ] Test backup USB drive
- [ ] Verify monitor settings haven't reset

### Quarterly
- [ ] Deep clean all peripherals
- [ ] Test USB drive performance (check for degradation)
- [ ] Recalibrate monitor if needed
- [ ] Replace wireless device batteries if low

## Conclusion

All your peripherals are fully compatible with Linux and should work perfectly out of the box. The RedThunder keyboard and mouse use standard HID protocols, the SSK USB-C drive is universally supported, and the Acer Nitro gaming monitor will work at full 165Hz with any modern Linux distribution.

For the best experience:
1. Use the SSK USB-C flash drive to create your installation media
2. Install Ubuntu 24.04 LTS or Pop!_OS 22.04 LTS
3. After installation, enable 165Hz in display settings
4. Enjoy your high-performance Linux Mini-PC setup!
