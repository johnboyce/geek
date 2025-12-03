# Gaming Setup Guide

## Gaming on Linux Overview

The Geekom AX8 with AMD Radeon 780M is capable of:
- 1080p gaming at medium-high settings
- Excellent performance for indie games and esports titles
- Good performance for older AAA games
- Some modern AAA games at lower settings

## Essential Gaming Software

### Steam

```bash
# Install Steam (flatpak recommended for better compatibility)
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.valvesoftware.Steam

# Or via apt (Ubuntu)
sudo apt install -y steam

# Launch Steam
steam
# Or: flatpak run com.valvesoftware.Steam
```

Enable Proton in Steam:
1. Open Steam
2. Settings → Steam Play
3. Check "Enable Steam Play for all other titles"
4. Select Proton version (latest recommended)
5. Restart Steam

### Lutris (Game Manager)

```bash
# Install Lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install -y lutris

# Install dependencies for various platforms
sudo apt install -y wine64 wine32 winetricks
```

### Heroic Games Launcher (Epic Games, GOG)

```bash
# Install via flatpak
flatpak install -y flathub com.heroicgameslauncher.hgl

# Launch
flatpak run com.heroicgameslauncher.hgl
```

### ProtonUp-Qt (Manage Proton/Wine Versions)

```bash
# Install via flatpak
flatpak install -y flathub net.davidotek.pupgui2

# Use to install:
# - GE-Proton (community Proton with improvements)
# - Wine-GE (Wine for Lutris)
# - Latest Proton versions
```

## Graphics Drivers

### AMD Mesa Drivers

Ubuntu 24.04+ includes recent Mesa drivers by default:

```bash
# Check current Mesa version
glxinfo | grep "OpenGL version"

# Install latest Mesa (if needed)
sudo add-apt-repository ppa:kisak/kisak-mesa
sudo apt update
sudo apt full-upgrade

# Install Vulkan support
sudo apt install -y mesa-vulkan-drivers vulkan-tools

# Verify Vulkan
vulkaninfo --summary
```

### AMD GPU Tools

```bash
# Install monitoring tools
sudo apt install -y radeontop

# Monitor GPU usage
radeontop

# Or use
watch -n 1 cat /sys/class/drm/card*/device/gpu_busy_percent
```

## Performance Optimization

### GameMode (Feral Interactive)

Automatically optimizes system for gaming:

```bash
# Install GameMode
sudo apt install -y gamemode

# Verify installation
gamemoded -t

# GameMode will auto-activate for Steam games
# For other games, prefix with: gamemoderun ./game
```

### MangoHud (Performance Overlay)

Display FPS, GPU/CPU usage in games:

```bash
# Install MangoHud
sudo apt install -y mangohud

# Use with Steam games:
# Right-click game → Properties → Launch Options
# Add: mangohud %command%

# Or run any game with:
mangohud ./game
```

Configure MangoHud:
```bash
mkdir -p ~/.config/MangoHud
nano ~/.config/MangoHud/MangoHud.conf
```

Sample config:
```ini
# Position (top-left, top-right, bottom-left, bottom-right)
position=top-left

# Metrics to display
fps
frame_timing
gpu_stats
cpu_stats
ram
vram

# Appearance
font_size=24
background_alpha=0.5
```

### CPU Governor

Set CPU to performance mode while gaming:

```bash
# Install cpupower
sudo apt install -y linux-tools-common linux-tools-generic

# Check current governor
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Set to performance
sudo cpupower frequency-set -g performance

# Or create toggle script
nano ~/scripts/gaming-mode.sh
```

```bash
#!/bin/bash
if [ "$1" == "on" ]; then
    echo "Enabling gaming mode..."
    sudo cpupower frequency-set -g performance
    echo "Performance governor enabled"
elif [ "$1" == "off" ]; then
    echo "Disabling gaming mode..."
    sudo cpupower frequency-set -g schedutil
    echo "Schedutil governor enabled"
else
    echo "Usage: $0 {on|off}"
fi
```

```bash
chmod +x ~/scripts/gaming-mode.sh

# Use: ~/scripts/gaming-mode.sh on
```

### System Tweaks

```bash
# Disable desktop compositor (can improve FPS)
# For GNOME:
gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"

# Increase vm.max_map_count (for games like Windows games via Proton)
echo 'vm.max_map_count=2147483642' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

## Native Linux Games

### Recommended Native Games

Popular native Linux games:
- **CS:GO / CS2** (Valve)
- **Dota 2** (Valve)
- **Civilization VI** (2K Games)
- **Terraria** (Re-Logic)
- **Factorio** (Wube Software)
- **Stardew Valley** (ConcernedApe)
- **Hollow Knight** (Team Cherry)
- **RimWorld** (Ludeon Studios)
- **Divinity: Original Sin 2** (Larian Studios)
- **Total War series** (Creative Assembly)

Most indie games have native Linux support!

## Windows Games via Proton

### Proton Compatibility

Check game compatibility: [ProtonDB.com](https://www.protondb.com)

Ratings:
- **Platinum**: Works perfectly
- **Gold**: Works great with minor issues
- **Silver**: Runs but has issues
- **Bronze**: Runs poorly
- **Borked**: Doesn't work

### Proton Tips

```bash
# Force specific Proton version for a game:
# Right-click game → Properties → Compatibility
# Check "Force the use of a specific Steam Play compatibility tool"
# Select version

# Common launch options:
# PROTON_USE_WINED3D=1 %command%  # Use D3D11 instead of DXVK
# PROTON_NO_ESYNC=1 %command%     # Disable esync
# PROTON_NO_FSYNC=1 %command%     # Disable fsync
# gamemoderun %command%            # Enable GameMode
# mangohud %command%               # Enable MangoHud overlay
```

### Anti-Cheat Support

Many anti-cheat systems now work on Linux:
- **EAC (Easy Anti-Cheat)**: Supported (if developer enables)
- **BattlEye**: Supported (if developer enables)
- **Vanguard (Valorant)**: Not supported
- **Ricochet (Call of Duty)**: Not supported

Check before buying if multiplayer is important!

## Emulation

### RetroArch (All-in-one Emulator)

```bash
# Install RetroArch
flatpak install -y flathub org.libretro.RetroArch

# Launch
flatpak run org.libretro.RetroArch
```

### PCSX2 (PS2 Emulator)

```bash
flatpak install -y flathub net.pcsx2.PCSX2
```

### RPCS3 (PS3 Emulator)

```bash
flatpak install -y flathub net.rpcs3.RPCS3
```

### Dolphin (GameCube/Wii Emulator)

```bash
flatpak install -y flathub org.DolphinEmu.dolphin-emu
```

### PPSSPP (PSP Emulator)

```bash
flatpak install -y flathub org.ppsspp.PPSSPP
```

## Game Controllers

### Xbox Controllers

Work out of the box via USB or Bluetooth:

```bash
# Install xpadneo for better wireless support
sudo apt install -y dkms

git clone https://github.com/atar-axis/xpadneo.git
cd xpadneo
sudo ./install.sh

# Pair controller via Bluetooth
# Press Xbox + Pair buttons simultaneously
# Use system Bluetooth settings to connect
```

### PlayStation Controllers

```bash
# Install DS4DRV for DualShock 4
sudo apt install -y python3-pip
sudo pip3 install ds4drv

# Run
sudo ds4drv

# For DualSense (PS5 controller) - works natively in newer kernels
# Just pair via Bluetooth
```

### Controller Configuration

Use Steam's controller configuration:
1. Steam → Settings → Controller
2. Enable configuration support for your controller
3. Per-game: Right-click game → Manage → Controller configuration

## Performance Benchmarking

### Useful Benchmarks

```bash
# Install Unigine Superposition (via Steam or website)
# Native OpenGL benchmark

# Install glxgears (basic GL test)
sudo apt install -y mesa-utils
glxgears

# 3DMark via Proton (on Steam)
# Basemark GPU (free native benchmark)
```

### Monitor Performance

```bash
# Install htop
sudo apt install -y htop

# GPU monitoring
watch -n 1 cat /sys/class/drm/card*/device/gpu_busy_percent

# Or radeontop
radeontop
```

## Gaming Performance Tips

### Expectations for Popular Games

**Excellent (60+ FPS @ 1080p High)**:
- CS:GO/CS2
- Dota 2
- League of Legends
- Valorant (if supported)
- Rocket League
- Fortnite (if supported)
- Most indie games

**Good (45-60 FPS @ 1080p Medium)**:
- Cyberpunk 2077 (with FSR)
- Red Dead Redemption 2 (medium)
- Elden Ring
- GTA V
- The Witcher 3

**Playable (30-45 FPS @ 1080p Low-Medium)**:
- Starfield (with FSR)
- Hogwarts Legacy
- Modern AAA titles (2023+)

### Improve Performance

1. **Lower resolution**: 1600x900 or 1280x720
2. **Enable FSR**: AMD FidelityFX Super Resolution
3. **Reduce settings**: Shadows, anti-aliasing first
4. **Use Game Mode**: `gamemoderun`
5. **Close background apps**: Free up RAM and CPU
6. **Update drivers**: Latest Mesa for best performance
7. **Use native when available**: Better than Proton
8. **Try different Proton versions**: GE-Proton often better

## Troubleshooting

### Game won't start

1. Check ProtonDB for known issues
2. Try different Proton version
3. Install dependencies: `winetricks -q vcrun2019 dotnet48`
4. Check launch options
5. Verify game files in Steam

### Poor performance

1. Check GPU is being used: `radeontop`
2. Enable Game Mode
3. Set CPU governor to performance
4. Close background applications
5. Lower graphics settings
6. Enable FSR if available
7. Check thermals aren't throttling

### Controller not working

1. Check it's detected: `ls /dev/input/js*`
2. Test with `jstest /dev/input/js0`
3. Configure in Steam Big Picture mode
4. Try different USB port
5. Update controller firmware

### Audio issues

```bash
# Switch to Pipewire (better for gaming)
sudo apt install -y pipewire pipewire-pulse wireplumber

# Restart
systemctl --user restart pipewire pipewire-pulse wireplumber
```

## Gaming Resources

- **ProtonDB**: https://www.protondb.com - Game compatibility database
- **Wine AppDB**: https://appdb.winehq.org - Wine compatibility
- **GamingOnLinux**: https://www.gamingonlinux.com - News and guides
- **r/linux_gaming**: Reddit community
- **Lutris**: https://lutris.net - Install scripts for many games
- **Are We Anti-Cheat Yet**: https://areweanticheatyet.com - Anti-cheat status

## Cloud Gaming

If native/Proton performance isn't enough:

### GeForce NOW
```bash
# Works in browser (Chrome/Edge)
# Or use unofficial client
flatpak install -y flathub io.github.hmlendea.geforcenow-electron
```

### Xbox Cloud Gaming
- Works in Edge browser
- Requires Xbox Game Pass Ultimate

### Steam Link (stream from gaming PC)
```bash
flatpak install -y flathub com.valvesoftware.SteamLink
```
