#
#
#
all: 


build:
	sudo docker build -t jdougan/base-xrgb-chrome:v1 .

run:
	sudo docker run -p 5900:5900 jdougan/base-xrgb-chrome:v1