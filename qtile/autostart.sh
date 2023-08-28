#!/usr/bin/env bash 

lxsession &
#picom &
killall conky
sleep 2 && conky -c "$HOME"/.config/conky/Dracula.conkyrc &
# volumeicon &
# nm-applet &
