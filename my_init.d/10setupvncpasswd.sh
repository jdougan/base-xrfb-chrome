#!/bin/bash
echo "=1=1=1=1=1=1=1= " $*
x11vnc -storepasswd ${XRFBPASSWD} /vnc/vncpasswd
