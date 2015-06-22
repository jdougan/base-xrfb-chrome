#!/bin.bash
export XRFBSESSIONID=chrome5901
export XRFBSESSIONSDIR=~/xrfb-sessions/
export XRFBSESSIONDIR=${XRFBSESSIONSDIR}/${XRFBSESSIONID}
rm -rf  ${XRFBSESSIONDIR}
mkdir -p  ${XRFBSESSIONDIR}
echo -n 'XRFBPASSWD=' > ${XRFBSESSIONDIR}/environment
echo 'tea41dragon' >> ${XRFBSESSIONDIR}/environment
if [ $# -eq 1 ]
then
echo -n 'XRFBURI=' >> ${XRFBSESSIONDIR}/environment
echo $1 >> ${XRFBSESSIONDIR}/environment
else
echo -n 'XRFBURI=' >> ${XRFBSESSIONDIR}/environment
echo "" >> ${XRFBSESSIONDIR}/environment
fi
export XRFBHOSTPORT=5901
docker run -p ${XRFBHOSTPORT}:5900 -e XRFBRESX=1000 -e XRFBRESY=1000 -e XRFBDEPTH=24 --env-file ${XRFBSESSIONDIR}/environment \
    --cidfile=${XRFBSESSIONDIR}/containerid  --label=net.opencobalt.xrfb.session=${XRFBSESSIONID} \
    jdougan/base-xrfb-chrome:1
