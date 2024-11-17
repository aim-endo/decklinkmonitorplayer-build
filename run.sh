#!/bin/bash

DISPLAY=:0 docker run -it --rm \
    --name=decklinkmonitorplayer \
    --hostname=decklinkmonitorplayer \
    -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY \
    -v /home/$(id -u -n)/Workspace:/home/$(id -u -n)/Workspace \
    -v /opt/nvidia:/opt/nvidia \
    -v /dev/blackmagic:/dev/blackmagic \
    -v /usr/lib/blackmagic:/usr/lib/blackmagic \
    -v /usr/lib/libDeckLinkAPI.so:/usr/lib/libDeckLinkAPI.so \
    -v /usr/lib/libDeckLinkPreviewAPI.so:/usr/lib/libDeckLinkPreviewAPI.so \
    -p 3022:22 \
    aim-endo/decklinkmonitorplayer:latest zsh
