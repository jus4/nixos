#!/bin/sh

# Check battery percentage
BATTERY_LEVEL=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | tr -d '%')

# Suspend if battery is at or below 10%
if [ "$BATTERY_LEVEL" -le 10 ]; then
  systemctl suspend
fi
