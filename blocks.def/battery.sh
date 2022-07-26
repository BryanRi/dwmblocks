#!/bin/sh
ICON=""
BAT_DIR="/sys/class/power_supply/BAT0"
read -r capacity < "$BAT_DIR/capacity"
if [ "$(cat $BAT_DIR/status)" = "Charging" ]; then
    [ "$capacity" -ge 85 ] && printf "\x0c AC:%s%% \x0b" "$capacity" && exit 0
    printf "AC:%s%%" "$capacity"
else
    [ "$capacity" -gt 15 ] && printf "B:%s%%" "$capacity" && exit 0
    read -r rate < "$BAT_DIR"/current_now
    read -r val < "$BAT_DIR"/charge_now
    hr="$(( val / rate ))"
    mn="$(( (val % rate * 60) / rate ))"
    printf "\x0c B:%s%% (%s:%s) \x0b" "$capacity" "$hr" "$mn" && exit 0
fi
