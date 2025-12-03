# Video Streaming and Media Server Setup

## Overview

The Geekom AX8 excels at media tasks with:
- Hardware-accelerated video encoding/decoding (H.264, H.265/HEVC, AV1)
- 4K video playback
- Multi-display support
- Low power consumption for 24/7 operation

## Video Playback

### MPV (Recommended Media Player)

```bash
# Install MPV
sudo apt install -y mpv

# Enable hardware acceleration
mkdir -p ~/.config/mpv
nano ~/.config/mpv/mpv.conf
```

```ini
# Hardware acceleration
hwdec=auto
vo=gpu
gpu-context=wayland

# High quality
profile=gpu-hq
scale=ewa_lanczossharp
cscale=ewa_lanczossharp

# Deinterlacing
deinterlace=auto

# Audio
audio-channels=stereo
volume=100
volume-max=150
```

### VLC Media Player

```bash
# Install VLC
sudo apt install -y vlc

# Or via snap
sudo snap install vlc
```

Enable hardware acceleration in VLC:
1. Tools → Preferences
2. Input / Codecs
3. Hardware-accelerated decoding: VA-API

### VAAPI (Video Acceleration API)

Check hardware acceleration support:

```bash
# Install VA-API utilities
sudo apt install -y vainfo

# Check capabilities
vainfo

# Should show H264, HEVC, VP9 support
```

## Streaming to This PC

### OBS Studio (Receive Streams)

```bash
# Install OBS Studio
sudo apt install -y obs-studio

# Or latest via flatpak
flatpak install -y flathub com.obsproject.Studio
```

### RTMP Server Setup

Set up to receive streams from other devices:

```bash
# Install nginx with RTMP module
sudo apt install -y nginx libnginx-mod-rtmp

# Configure RTMP
sudo nano /etc/nginx/nginx.conf
```

Add at the end:
```nginx
rtmp {
    server {
        listen 1935;
        chunk_size 4096;
        
        application live {
            live on;
            record off;
            
            # Allow publishing from local network only
            allow publish 192.168.1.0/24;
            deny publish all;
            
            # Allow playing from anywhere
            allow play all;
        }
    }
}
```

```bash
# Restart nginx
sudo systemctl restart nginx

# Allow RTMP through firewall
sudo ufw allow 1935/tcp comment 'RTMP'
```

Stream to: `rtmp://your-ip/live/stream_key`
Watch at: `rtmp://your-ip/live/stream_key`

## Streaming from This PC

### OBS Studio Configuration

Optimal settings for streaming:

**Video:**
- Base Resolution: 1920x1080
- Output Resolution: 1920x1080 or 1280x720
- FPS: 30 or 60

**Output (Advanced):**
```
Encoder: FFMPEG VAAPI
Rate Control: CBR
Bitrate: 
  - 1080p60: 6000 kbps
  - 1080p30: 4500 kbps
  - 720p60: 4500 kbps
  - 720p30: 3000 kbps
Profile: high
Level: auto
```

### Hardware Encoding Setup

```bash
# Verify VAAPI encoding support
vainfo | grep Encode

# Install FFmpeg with VAAPI
sudo apt install -y ffmpeg

# Test hardware encoding
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -i input.mp4 -c:v h264_vaapi output.mp4
```

### Streaming Platforms

#### Twitch
- Server: Closest Twitch ingest server
- Stream Key: From Twitch dashboard
- Bitrate: 3000-6000 kbps
- Encoder: VAAPI H.264

#### YouTube
- Server: rtmp://a.rtmp.youtube.com/live2
- Stream Key: From YouTube Studio
- Bitrate: 4500-9000 kbps
- Encoder: VAAPI H.264

#### Custom RTMP Server
- Server: rtmp://your-server/live
- Stream Key: custom_key
- Configure as needed

### SimpleScreenRecorder

Lightweight alternative to OBS:

```bash
sudo apt install -y simplescreenrecorder

# Use VAAPI for hardware encoding
```

## Media Server Solutions

### Plex Media Server

```bash
# Download and install Plex
wget https://downloads.plex.tv/plex-media-server-new/1.40.0.7998-c29d4c0c8/debian/plexmediaserver_1.40.0.7998-c29d4c0c8_amd64.deb

sudo dpkg -i plexmediaserver_*.deb
sudo apt install -f

# Enable and start service
sudo systemctl enable plexmediaserver
sudo systemctl start plexmediaserver

# Allow through firewall
sudo ufw allow 32400/tcp comment 'Plex'
```

Access: http://localhost:32400/web

Enable hardware transcoding (Plex Pass required):
1. Settings → Transcoder
2. Check "Use hardware acceleration when available"
3. Select VAAPI

### Jellyfin (Open Source Alternative)

```bash
# Add Jellyfin repository
curl https://repo.jellyfin.org/install-debuntu.sh | sudo bash

# Install
sudo apt install -y jellyfin

# Enable and start
sudo systemctl enable jellyfin
sudo systemctl start jellyfin

# Allow through firewall
sudo ufw allow 8096/tcp comment 'Jellyfin'
```

Access: http://localhost:8096

Enable hardware acceleration:
1. Dashboard → Playback
2. Hardware acceleration: Video Acceleration API (VAAPI)
3. VA-API Device: /dev/dri/renderD128
4. Enable H264, HEVC, VP9

### Emby (Alternative)

```bash
# Download Emby
wget https://github.com/MediaBrowser/Emby.Releases/releases/download/4.8.0.56/emby-server-deb_4.8.0.56_amd64.deb

sudo dpkg -i emby-server-deb_*.deb

# Enable and start
sudo systemctl enable emby-server
sudo systemctl start emby-server

# Allow through firewall
sudo ufw allow 8096/tcp comment 'Emby'
```

## DLNA/UPnP Media Server

### MiniDLNA

Simple DLNA server for local network:

```bash
# Install MiniDLNA
sudo apt install -y minidlna

# Configure
sudo nano /etc/minidlna.conf
```

```ini
# Media directories
media_dir=V,/path/to/videos
media_dir=A,/path/to/music
media_dir=P,/path/to/pictures

# Network interface
network_interface=eth0

# Friendly name
friendly_name=Geekom Media Server

# Automatic discovery
inotify=yes

# Database location
db_dir=/var/cache/minidlna

# Log location  
log_dir=/var/log
```

```bash
# Restart service
sudo systemctl restart minidlna

# Force rescan
sudo minidlnad -R
```

## Video Transcoding

### HandBrake (GUI)

```bash
# Install HandBrake
sudo apt install -y handbrake

# Or flatpak
flatpak install -y flathub fr.handbrake.ghb
```

### FFmpeg (Command Line)

Common transcoding tasks:

```bash
# Convert to H.265 with VAAPI
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -i input.mp4 \
  -vf 'format=nv12,hwupload' \
  -c:v hevc_vaapi -qp 25 \
  -c:a copy \
  output.mp4

# Convert to H.264 with VAAPI
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -i input.mp4 \
  -vf 'format=nv12,hwupload' \
  -c:v h264_vaapi -qp 22 \
  -c:a copy \
  output.mp4

# Batch convert all MKV to MP4
for file in *.mkv; do
  ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
    -i "$file" \
    -vf 'format=nv12,hwupload' \
    -c:v h264_vaapi -qp 22 \
    -c:a copy \
    "${file%.mkv}.mp4"
done

# Extract audio
ffmpeg -i input.mp4 -vn -c:a copy output.m4a

# 4K to 1080p downscale
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -i input_4k.mp4 \
  -vf 'scale_vaapi=w=1920:h=1080' \
  -c:v h264_vaapi -qp 22 \
  -c:a copy \
  output_1080p.mp4
```

## Live Streaming with FFmpeg

### Stream to Twitch

```bash
#!/bin/bash
# stream-to-twitch.sh

STREAM_KEY="your_twitch_stream_key"
RTMP_URL="rtmp://live.twitch.tv/app/$STREAM_KEY"

ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -f x11grab -video_size 1920x1080 -framerate 30 -i :0.0 \
  -f pulse -i default \
  -vf 'format=nv12,hwupload' \
  -c:v h264_vaapi -profile:v high -level 4.2 \
  -b:v 4500k -maxrate 4500k -bufsize 9000k \
  -g 60 -keyint_min 60 \
  -c:a aac -b:a 160k -ar 44100 \
  -f flv "$RTMP_URL"
```

### Stream to YouTube

```bash
#!/bin/bash
# stream-to-youtube.sh

STREAM_KEY="your_youtube_stream_key"
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"

ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -f x11grab -video_size 1920x1080 -framerate 60 -i :0.0 \
  -f pulse -i default \
  -vf 'format=nv12,hwupload' \
  -c:v h264_vaapi -profile:v high -level 4.2 \
  -b:v 6000k -maxrate 6000k -bufsize 12000k \
  -g 120 -keyint_min 120 \
  -c:a aac -b:a 160k -ar 44100 \
  -f flv "$RTMP_URL"
```

### Stream Webcam

```bash
# List video devices
v4l2-ctl --list-devices

# Stream webcam to RTMP
ffmpeg -f v4l2 -framerate 30 -video_size 1280x720 -i /dev/video0 \
  -f pulse -i default \
  -c:v h264_vaapi -b:v 3000k \
  -c:a aac -b:a 128k \
  -f flv rtmp://your-server/live/webcam
```

## IP Camera/DVR Setup

### Frigate NVR (AI Object Detection)

```bash
# Install Docker (if not already)
# See development-setup.md

# Create config directory
mkdir -p ~/frigate/config

# Create config file
nano ~/frigate/config/config.yml
```

```yaml
mqtt:
  enabled: false

cameras:
  front_door:
    ffmpeg:
      inputs:
        - path: rtsp://username:password@camera-ip:554/stream
          roles:
            - detect
            - rtmp
    width: 1280
    height: 720
    fps: 5
    
detectors:
  cpu1:
    type: cpu
```

```bash
# Run Frigate
docker run -d \
  --name frigate \
  --restart=unless-stopped \
  --mount type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000 \
  -v ~/frigate/config:/config \
  -v /etc/localtime:/etc/localtime:ro \
  -p 5000:5000 \
  -p 1935:1935 \
  ghcr.io/blakeblackshear/frigate:stable

# Access at http://localhost:5000
```

### MotionEye (Simple Camera DVR)

```bash
# Install dependencies
sudo apt install -y python3-pip motion ffmpeg

# Install MotionEye
sudo pip3 install motioneye

# Configure
sudo motioneye_init

# Start service
sudo systemctl start motioneye

# Access at http://localhost:8765
# Default user: admin, no password
```

## Performance Monitoring

### Monitor Hardware Acceleration

```bash
# Watch GPU usage during encode/decode
watch -n 1 cat /sys/class/drm/card*/device/gpu_busy_percent

# Or use radeontop
radeontop

# Monitor video engines specifically
sudo intel_gpu_top  # Won't work for AMD, use radeontop
```

### Check Stream Health

```bash
# Monitor network bandwidth
sudo apt install -y iftop
sudo iftop -i eth0

# Check dropped frames in OBS
# Stats → Dropped Frames should be < 1%
```

## Optimization Tips

### Best Practices

1. **Use hardware acceleration**: Always use VAAPI when possible
2. **Bitrate guidelines**:
   - 1080p60: 6000 kbps
   - 1080p30: 4500 kbps
   - 720p60: 4500 kbps
   - 720p30: 3000 kbps
3. **Keyframe interval**: 2 seconds (FPS × 2)
4. **CPU Preset**: Not applicable with VAAPI, but use "medium" for software
5. **Audio**: AAC 160 kbps, 44.1 kHz

### Network Optimization

```bash
# Increase network buffer sizes
sudo sysctl -w net.core.rmem_max=26214400
sudo sysctl -w net.core.wmem_max=26214400

# Make permanent
echo 'net.core.rmem_max=26214400' | sudo tee -a /etc/sysctl.conf
echo 'net.core.wmem_max=26214400' | sudo tee -a /etc/sysctl.conf
```

### Storage Considerations

For media server:
- Use separate drive/partition for media
- SSD for database and thumbnails
- HDD is fine for video storage
- Plan for ~1-2 GB per hour of HD video
- HEVC/H.265 saves ~30-50% vs H.264

## Troubleshooting

### Hardware acceleration not working

```bash
# Check device permissions
ls -l /dev/dri/
sudo usermod -aG render,video $USER
# Log out and back in

# Verify VAAPI
vainfo

# Test encoding
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
  -f lavfi -i testsrc=duration=10:size=1920x1080:rate=30 \
  -vf 'format=nv12,hwupload' \
  -c:v h264_vaapi test.mp4
```

### Stream buffering/stuttering

1. Reduce bitrate
2. Lower resolution
3. Check network connection
4. Check CPU/GPU usage
5. Close other applications

### Poor quality

1. Increase bitrate
2. Use higher preset (if software encoding)
3. Check source quality
4. Verify resolution settings
5. Check for dropped frames

### Audio sync issues

```bash
# Add audio delay in FFmpeg (positive = delay audio)
-itsoffset 0.5 -i audio_input

# Or in OBS: Advanced Audio Properties → Sync Offset
```

## Resources

- **OBS Studio**: https://obsproject.com
- **FFmpeg Documentation**: https://ffmpeg.org/documentation.html
- **Jellyfin**: https://jellyfin.org
- **Plex**: https://www.plex.tv
- **Streamlink**: https://streamlink.github.io (record/watch streams)
