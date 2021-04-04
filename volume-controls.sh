#!/bin/bash

function increase_volume {
    pactl -- set-sink-volume 1 +5%
    send_volume_notification
}

function decrease_volume {
    pactl -- set-sink-volume 1 -5%
    send_volume_notification
}

function toggle_mute {
    MUTED=$(pactl list sinks | perl -000ne 'if(/#1/){/(Mute:.*)/; print "$1\n"}' | awk '{ print $2 }')
    if [ $MUTED = 'yes' ] 
    then
        pactl -- set-sink-mute 1 0
        notify-send -t 1000 "Unmuted" -h string:x-canonical-private-synchronous:sound-control
    else
        pactl -- set-sink-mute 1 1
        notify-send -t 1000 "Muted" -h string:x-canonical-private-synchronous:sound-control
    fi
}

function get_volume {
    pactl list sinks | perl -000ne 'if(/#1/){/(Volume:.*)/; print "$1\n"}' | awk '{ print $5 }'
}

function send_volume_notification {
    VOL=$( get_volume )
    notify-send -t 1000 "Volume: $VOL" -h string:x-canonical-private-synchronous:sound-control
}

case $1 in
    'up')
        increase_volume
        ;;
    'down')
        decrease_volume
        ;;
    'mute')
        toggle_mute
        ;;
esac
