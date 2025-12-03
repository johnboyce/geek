# Troubleshooting Guide

## System Won't Boot

### Black Screen After GRUB

**Symptoms**: GRUB menu appears, but system hangs on black screen

**Solutions**:
```bash
# At GRUB menu, press 'e' to edit boot entry
# Find line starting with 'linux'
# Add 'nomodeset' before 'quiet splash'
# Press Ctrl+X to boot

# If that works, make permanent:
sudo nano /etc/default/grub
# Add: GRUB_CMDLINE_LINUX_DEFAULT="nomodeset quiet splash"
sudo update-grub
```

### Kernel Panic

**Symptoms**: Kernel panic message on boot

**Solutions**:
```bash
# Boot from USB installer
# Mount root partition
sudo mount /dev/nvme0n1p3 /mnt  # Adjust partition number
sudo mount /dev/nvme0n1p1 /mnt/boot/efi  # Mount EFI partition

# Chroot into system
sudo chroot /mnt

# Reinstall kernel
apt install --reinstall linux-image-generic

# Update GRUB
update-grub

# Exit and reboot
exit
sudo umount /mnt/boot/efi
sudo umount /mnt
reboot
```

### GRUB Rescue Mode

**Symptoms**: "grub rescue>" prompt

**Solutions**:
```bash
# At grub rescue prompt:
set prefix=(hd0,gpt3)/boot/grub  # Adjust partition
set root=(hd0,gpt3)
insmod normal
normal

# After booting, reinstall GRUB:
sudo grub-install /dev/nvme0n1
sudo update-grub
```

## Graphics Issues

### Screen Tearing

**Solution**:
```bash
# For X11
sudo nano /etc/X11/xorg.conf.d/20-amdgpu.conf
```

```
Section "Device"
    Identifier "AMD"
    Driver "amdgpu"
    Option "TearFree" "true"
EndSection
```

```bash
# For Wayland (GNOME)
# Enable VRR
gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"
```

### External Display Not Detected

```bash
# Check connected displays
xrandr --listmonitors

# Force detection
xrandr --auto

# Check kernel messages
dmesg | grep -i hdmi

# Try different port
# Update firmware
sudo fwupdmgr refresh
sudo fwupdmgr update
```

### Low Resolution or Framebuffer Mode

```bash
# Remove nomodeset if you added it
sudo nano /etc/default/grub
# Remove 'nomodeset' from GRUB_CMDLINE_LINUX_DEFAULT
sudo update-grub
reboot

# Install proper AMD drivers
sudo apt install --reinstall xserver-xorg-video-amdgpu
```

## Wi-Fi Issues

### Wi-Fi Not Showing

```bash
# Check if device is detected
lspci | grep -i wireless
ip link show

# Check if driver is loaded
lsmod | grep -i wifi

# Install firmware
sudo apt install linux-firmware
sudo reboot

# If still not working, try:
sudo apt install --reinstall linux-modules-extra-$(uname -r)
sudo reboot
```

### Wi-Fi Drops Frequently

```bash
# Disable power management for Wi-Fi
sudo nano /etc/NetworkManager/conf.d/wifi-powersave.conf
```

```ini
[connection]
wifi.powersave = 2
```

```bash
sudo systemctl restart NetworkManager

# Check for interference
sudo iwlist wlan0 scan | grep -i channel

# Switch to 5GHz if possible (less interference)
```

### Slow Wi-Fi

```bash
# Check connection quality
iwconfig wlan0

# Check signal strength
watch -n 1 cat /proc/net/wireless

# Test speed
sudo apt install speedtest-cli
speedtest-cli

# Disable IPv6 if causing issues
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
```

## Audio Issues

### No Sound

```bash
# Check audio devices
aplay -l

# Test sound
speaker-test -c 2

# Check volume
alsamixer

# Restart audio services
systemctl --user restart pipewire pipewire-pulse wireplumber

# Or for PulseAudio:
pulseaudio -k
pulseaudio --start
```

### Wrong Audio Device Selected

```bash
# List devices
pactl list sinks short

# Set default
pactl set-default-sink <sink_name>

# Or use pavucontrol (GUI)
sudo apt install pavucontrol
pavucontrol
```

### Audio Crackling/Popping

```bash
# Increase buffer size
sudo nano /etc/pulse/daemon.conf
# Uncomment and modify:
# default-fragments = 5
# default-fragment-size-msec = 2

pulseaudio -k
pulseaudio --start

# For Pipewire:
mkdir -p ~/.config/pipewire
cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
nano ~/.config/pipewire/pipewire.conf
# Increase quantum values
```

## USB Issues

### USB Device Not Recognized

```bash
# Check USB devices
lsusb
dmesg | grep -i usb

# Check USB power settings
cat /sys/module/usbcore/parameters/autosuspend

# Disable USB autosuspend
echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend

# Make permanent
sudo nano /etc/default/grub
# Add: GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1"
sudo update-grub
```

### USB 3.0 Devices Run at USB 2.0 Speed

```bash
# Check USB speed
lsusb -t

# Update firmware
sudo fwupdmgr refresh
sudo fwupdmgr update

# Check BIOS settings for USB 3.0/XHCI
```

## Bluetooth Issues

### Bluetooth Not Working

```bash
# Check Bluetooth service
sudo systemctl status bluetooth

# Start if not running
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Check if adapter is detected
hciconfig
rfkill list

# Unblock if blocked
sudo rfkill unblock bluetooth

# Restart Bluetooth
sudo systemctl restart bluetooth
```

### Can't Pair Device

```bash
# Remove old pairing
bluetoothctl
remove <device_mac>
exit

# Reinstall Bluetooth stack
sudo apt install --reinstall bluez

# Check logs
journalctl -u bluetooth -f
```

## Performance Issues

### System Running Slow

```bash
# Check CPU usage
top
htop

# Check memory usage
free -h

# Check disk usage
df -h

# Check for hung processes
ps aux | grep D

# Check system load
uptime

# Check for errors
dmesg | grep -i error
journalctl -p err -b
```

### High CPU Temperature

```bash
# Install monitoring tools
sudo apt install lm-sensors

# Detect sensors
sudo sensors-detect

# Check temperatures
sensors

# Check throttling
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq

# Clean dust from vents
# Ensure proper ventilation
# Consider undervolting if necessary
```

### Disk Performance Issues

```bash
# Check disk health
sudo smartctl -H /dev/nvme0n1

# Run full SMART test
sudo smartctl -t long /dev/nvme0n1

# Check disk I/O
sudo iotop

# Check if TRIM is enabled
sudo fstrim -v /

# Benchmark disk
sudo apt install hdparm
sudo hdparm -Tt /dev/nvme0n1
```

## Network Issues

### Can't Connect to Internet

```bash
# Check network interfaces
ip link show

# Check IP address
ip addr show

# Ping gateway
ip route show
ping <gateway_ip>

# Ping DNS
ping 8.8.8.8

# Check DNS resolution
nslookup google.com

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

### Slow Network Speed

```bash
# Test speed
sudo apt install speedtest-cli
speedtest-cli

# Check for packet loss
ping -c 100 8.8.8.8

# Check MTU
ip link show | grep mtu

# Optimize MTU if needed
sudo ip link set dev eth0 mtu 1500

# Check for errors
ethtool eth0
```

### SSH Connection Refused

```bash
# Check if SSH server is running
sudo systemctl status sshd

# Start SSH server
sudo systemctl start sshd

# Check firewall
sudo ufw status

# Allow SSH
sudo ufw allow 22/tcp

# Check SSH configuration
sudo sshd -t

# Check logs
sudo journalctl -u sshd -n 50
```

## Docker Issues

### Docker Container Won't Start

```bash
# Check Docker service
sudo systemctl status docker

# View container logs
docker logs <container_name>

# Check container status
docker ps -a

# Restart Docker
sudo systemctl restart docker

# Clean up
docker system prune -a
```

### Permission Denied Errors

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in

# Verify group membership
groups

# Set correct permissions
sudo chmod 666 /var/run/docker.sock
```

## Application Crashes

### Collect Crash Information

```bash
# Check system logs
sudo journalctl -xe

# Check application logs
journalctl -f

# Check for core dumps
coredumpctl list
coredumpctl info <pid>

# Check kernel logs
dmesg | tail -50

# Run application from terminal to see errors
<application_command>
```

### Application Won't Start

```bash
# Check if already running
ps aux | grep <application>

# Check dependencies
ldd /usr/bin/<application>

# Reinstall application
sudo apt install --reinstall <package>

# Check configuration
# Most configs in ~/.config/ or /etc/

# Reset configuration
mv ~/.config/<application> ~/.config/<application>.backup
```

## Package Management Issues

### Broken Packages

```bash
# Fix broken packages
sudo apt --fix-broken install

# Reconfigure packages
sudo dpkg --configure -a

# Clean package cache
sudo apt clean
sudo apt autoclean

# Update package lists
sudo apt update

# Upgrade packages
sudo apt full-upgrade
```

### PPA Issues

```bash
# List PPAs
grep -r --include '*.list' '^deb ' /etc/apt/sources.list /etc/apt/sources.list.d/

# Remove problematic PPA
sudo add-apt-repository --remove ppa:someppa/ppa

# Or manually remove
sudo rm /etc/apt/sources.list.d/<ppa_file>
sudo apt update
```

### Held Packages

```bash
# List held packages
dpkg --get-selections | grep hold

# Unhold package
sudo apt-mark unhold <package>

# Hold package (prevent updates)
sudo apt-mark hold <package>
```

## System Recovery

### Boot into Recovery Mode

1. Restart computer
2. Hold Shift during boot to show GRUB
3. Select "Advanced options"
4. Select "Recovery mode"
5. Choose action (repair, root shell, etc.)

### Reinstall Desktop Environment

```bash
# For GNOME
sudo apt install --reinstall ubuntu-desktop

# For KDE Plasma
sudo apt install --reinstall kubuntu-desktop

# For XFCE
sudo apt install --reinstall xubuntu-desktop
```

### Reset User Settings

```bash
# Backup current settings
mv ~/.config ~/.config.backup
mv ~/.local ~/.local.backup

# Log out and back in
# System will recreate default configs
```

## Data Recovery

### Recover Deleted Files

```bash
# Install TestDisk/PhotoRec
sudo apt install testdisk

# Run PhotoRec for file recovery
sudo photorec

# Or TestDisk for partition recovery
sudo testdisk
```

### Mount Read-Only Filesystem

```bash
# Remount as read-write
sudo mount -o remount,rw /

# Or specific partition
sudo mount -o remount,rw /dev/nvme0n1p3 /
```

## Common Error Messages

### "Command not found"

```bash
# Update PATH
echo $PATH

# Add to PATH if needed
export PATH=$PATH:/usr/local/bin

# Reinstall package
sudo apt install --reinstall <package>
```

### "Permission denied"

```bash
# Check file permissions
ls -l <file>

# Fix permissions
sudo chmod +x <file>
sudo chown $USER:$USER <file>

# Or use sudo
sudo <command>
```

### "No space left on device"

```bash
# Check disk space
df -h

# Find large files
sudo du -ah / | sort -rh | head -20

# Clean up
sudo apt autoclean
sudo apt autoremove
docker system prune -a

# Clear journal logs
sudo journalctl --vacuum-size=100M

# Clear thumbnail cache
rm -rf ~/.cache/thumbnails/*
```

## Getting Help

### Collect System Information

```bash
# Create system report
sudo apt install inxi
inxi -Fxz

# Hardware info
lshw -short

# Kernel info
uname -a

# Distribution info
lsb_release -a

# Logs
journalctl -b > ~/system_logs.txt
```

### Useful Commands for Troubleshooting

```bash
# System logs
journalctl -xe
dmesg
tail -f /var/log/syslog

# Process information
ps aux
top
htop

# Network
ip addr
ss -tuln
netstat -tulpn

# Disk
lsblk
df -h
mount

# Hardware
lspci
lsusb
lscpu
free -h
```

### Where to Get Help

- **Ubuntu Forums**: https://ubuntuforums.org
- **Ask Ubuntu**: https://askubuntu.com
- **Reddit**: r/linux4noobs, r/linuxquestions
- **Linux Stack Exchange**: https://unix.stackexchange.com
- **IRC**: #ubuntu on Libera.Chat
- **Official Documentation**: https://help.ubuntu.com
