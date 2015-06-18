#
#
#
all: 


build:
	sudo docker build -t jdougan/base-xrfb-chrome:1 .
build2:
	sudo docker build -t jdougan/base-xrfb-chrome:2 .

run:
	sudo docker run -p 5900:5900 jdougan/base-xrfb-chrome:1
run2:
	sudo docker run -p 5900:5900 jdougan/base-xrfb-chrome:2


gccon:
	docker ps -a | grep 'Exited' | awk '{print \$1}' | xargs --no-run-if-empty docker rm -v

gcim:
	docker ps -a | grep 'dsfsd' | awk '{print \$1}' | xargs --no-run-if-empty docker rmi  
