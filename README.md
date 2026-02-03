# Raspberry Pi Remote Video Looper (omxplayer + screen)

A simple, reliable digital-signage style video looper for Raspberry Pi OS / Raspbian Lite.
Plays all videos in a directory in sequence and loops forever using `omxplayer`.
Includes a controller script (start/stop/check/repair) using `screen`, plus example cron jobs
for scheduled on/off hours and self-healing.

## Features
- Fullscreen looping playback using `omxplayer`
- No keyboard/mouse required after setup
- Remote control over SSH:
  - start / stop / check / repair
- Auto-start on boot (via init.d registration)
- Optional cron schedule:
  - stop playback at night
  - reboot in the morning
  - auto-repair during business hours

## Tested on
- Raspberry Pi OS (Raspbian) Lite (Buster-compatible)

## Requirements
```bash
sudo apt-get update
sudo apt-get install -y omxplayer screen
