#
#
#
all: 


build:
	sudo docker build -t jdougan/base-xrfb-chrome:1 .

run:
	sudo docker run -p 5900:5900 jdougan/base-xrfb-chrome:1


gccon:
	docker ps -a | grep 'Exited' | awk '{print $1}' | xargs --no-run-if-empty docker rm -v

gcim:
