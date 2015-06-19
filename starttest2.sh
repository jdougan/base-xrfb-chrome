#!/bin.bash
export XRFBSESSIONID=testsession
echo -n 'XRFBPASSWD=' > ${XRFBSESSIONID}/xrfbpasswd
echo 'tea41dragon' >> ${XRFBSESSIONID}/xrfbpasswd
export XRFBHOSTPORT=5901
docker run -p ${XRFBHOSTPORT}:5900 -e XRFBRESX=1000 -e XRFBRESY=1000 -e XRFBDEPTH=24 --env-file xrfbpasswd \
    --cidfile=${XRFBSESSIONID}/containerid  --label=net.opencobalt.xrfb.session=${XRFBSESSIONID} \
    jdougan/base-xrfb-chrome:1
