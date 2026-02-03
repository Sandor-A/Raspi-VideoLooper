#!/usr/bin/env bash
set -euo pipefail

# Raspi-Videolooper
# Plays all videos in VPATH in a loop using omxplayer.
#
# Configure:
#   VPATH   - directory containing videos (no trailing slash required)
#   SHUFFLE - "1" to randomize playback order, "0" otherwise

VPATH="/home/pi/videos"
SHUFFLE="0"

LOGFILE="/var/log/raspi-videolooper.log"

# --- helpers ---
log() {
  # best-effort logging (won't crash if permissions block)
  local msg="$1"
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$msg" | sudo tee -a "$LOGFILE" >/dev/null 2>&1 || true
}

list_videos() {
  # Build a list of files. Assumes the folder contains only video files (as in the guide).
  # If you want filtering: replace with find -iname '*.mp4' etc.
  if [[ "$SHUFFLE" == "1" ]]; then
    ls -1 "$VPATH"/* 2>/dev/null | shuf
  else
    ls -1 "$VPATH"/* 2>/dev/null
  fi
}

# --- main ---
if [[ ! -d "$VPATH" ]]; then
  echo "ERROR: VPATH does not exist: $VPATH" >&2
  exit 1
fi

log "Starting videoloop. VPATH=$VPATH SHUFFLE=$SHUFFLE"

while true; do
  # If omxplayer is running, wait
  if pgrep -x omxplayer >/dev/null 2>&1; then
    sleep 1
    continue
  fi

  # Play each file in the directory
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    clear || true
    log "Playing: $entry"
    # -r : refresh rate/resync
    # redirect output to avoid clutter
    omxplayer -r "$entry" >/dev/null 2>&1 || log "omxplayer exited non-zero for: $entry"
  done < <(list_videos)

  # Small pause before restarting list
  sleep 1
done
