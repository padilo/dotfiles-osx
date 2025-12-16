#!/bin/sh

focused=$1
prev=$2

prev_active=active
if [ "$(aerospace list-windows --workspace $prev --count)" -eq "0" ]; then
  prev_active=0
fi

echo $prev_active

sketchybar \
  --set space.$prev background.color=0x220000EE icon.color=0xAAFFFFFF label.color=0xAAFFFFFF  display=$prev_active \
  --set space.$focused background.color=0xAA0000EE icon.color=0xFFFFFFFF label.color=0xFFFFFFFF display=active \

update_space_icons() {
    local sid=$1
    local apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    sketchybar --set space.$sid drawing=on

    if [ "${apps}" != "" ]; then
        icon_strip=" "
        while read -r app; do
            icon_strip+=" $(~/.config/sketchybar/icons/map.sh "$app")"
        done <<<"${apps}"
    else
        icon_strip=""
    fi
    sketchybar --set space.$sid label="$icon_strip"
}

update_space_icons "$prev"
