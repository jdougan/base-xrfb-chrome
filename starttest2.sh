#!/bin.bash
docker run -p 5900:5900 -e XRFBRESX=1000 -e XRFBRESY=1000 -e XRFBDEPTH=24  jdougan/base-xrfb-chrome:1
