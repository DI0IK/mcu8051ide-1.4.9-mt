#!/bin/bash

docker build -t mcu8051ide:1.4.9 .

xhost +local:docker

docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v mcu8051ide_home:/home/appuser \
  mcu8051ide:1.4.9