#!/bin.bash
docker run -p 5900:5900 -e XRFBRESX=1024 -e XRFBRESY=1024 -e XRFBDEPTH=24  jdougan/base-xrfb-chrome:1
