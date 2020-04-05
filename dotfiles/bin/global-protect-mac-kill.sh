#!/usr/bin/env bash

#PID=$(ps aux \
#  | grep /Applications/GlobalProtect.app/Contents/MacOS/GlobalProtect \
#  | grep -v grep \
#  | awk '{print $2}')
#
#echo $PID
#
#kill -9 $PID

# from here: https://git.io/JvBgt

set -uf

launchctl unload -w /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist
launchctl unload -w /Library/LaunchAgents/com.paloaltonetworks.gp.pangps.plist

while true; do
  sudo killall GlobalProtect || break
  sleep 1
done

while true; do
  sudo killall -9 GlobalProtect || break
  sleep 1
done

while true; do
  sudo killall PanGPS || break
  sleep 1
done

while true; do
  sudo killall -9 PanGPS || break
  sleep 1
done
