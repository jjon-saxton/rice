#!/usr/bin/env bash 

lxsession &
#picom &
/usr/bin/emacs --daemon &
killall conky
sleep 2 && conky -c "$HOME"/.config/conky/Dracula.conkyrc &
mpd &
# volumeicon &
# nm-applet &
