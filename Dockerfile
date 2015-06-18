# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.16

MAINTAINER John Dougan <void.random@gmail.com>
#derived from the chrome build by Tomohisa Kusano <siomiz@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

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
	x11vnc \
	xbase-clients \
	xdg-utils \
	xvfb \
	&& rm -rf /var/lib/apt/lists/*

ADD https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /chrome.deb
ADD https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb /crd.deb

RUN dpkg -i /chrome.deb && dpkg -i /crd.deb && rm /chrome.deb /crd.deb

RUN ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY supervisord-crdonly.conf /etc/supervisor/conf.d/supervisord-crdonly.conf

RUN addgroup chrome-remote-desktop && useradd -m -G chrome-remote-desktop,pulse-access chrome
ENV CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES 1024x768

ADD crdonly /crdonly
RUN chmod +x /crdonly

ADD crd-session /crd-session

VOLUME ["/home/chrome"]

COPY service.d /etc/service/
# RUN chmod +x /etc/service/supervisord/run

RUN mkdir -p /vnc
COPY vncpasswd /vnc/

EXPOSE 5900

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*