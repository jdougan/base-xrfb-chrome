#
# Dockerfile to build an Xrfb compatible chrome desktop.
#
#
#
FROM phusion/baseimage:0.9.16

MAINTAINER John Dougan <void.random@gmail.com>
#derived from the chrome build by Tomohisa Kusano <siomiz@gmail.com>
# https://askubuntu.com/questions/193130/what-is-the-most-basic-window-manager-for-ubuntu-that-can-be-used-to-display-a-s

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# setup for all Xrfb apps
ENV XRFBRESX=1024 XRFBRESY=768 XRFBDEPTH=24
RUN mkdir -p /vnc
RUN mkdir -p /data
COPY vncpasswd /vnc/
COPY service.d /etc/service/
COPY my_init.d /etc/my_init.d/
RUN useradd -m user

VOLUME ["/data"]
VOLUME ["/home/user"]
EXPOSE 5900

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	x11vnc \
	xbase-clients \
	xdg-utils \
	xvfb \
	ratpoison \
	&& echo "apt-get done"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# This appears to be where the chrome specific atuff starts.

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	ca-certificates \
	fonts-takao \
	gconf-service \
	gksu \
	libappindicator1 \
	libasound2 \
	libcurl3 \
	libgconf-2-4 \
	libnspr4 \
	libnss3 \
	libpango1.0-0 \
	pulseaudio \
	python-psutil \
	supervisor \
	wget \
	libcanberra-gtk-module \
	libexif-dev \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libv4l-0 \
	libxss1 \
	libxtst6 \
	&& rm -rf /var/lib/apt/lists/*

ADD https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /chrome.deb
ADD https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb /crd.deb

RUN dpkg -i /chrome.deb && dpkg -i /crd.deb && rm /chrome.deb /crd.deb

RUN ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY supervisord-crdonly.conf /etc/supervisor/conf.d/supervisord-crdonly.conf

RUN addgroup chrome-remote-desktop && usermod  --groups chrome-remote-desktop,pulse-access  user

ENV CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=${XRFBRESX}x${XRFBRESY}

ADD crdonly /crdonly
RUN chmod +x /crdonly

ADD crd-session /crd-session

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*