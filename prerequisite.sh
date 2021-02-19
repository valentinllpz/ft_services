#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
ORANGE='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
NC='\e[0m'

# #INSTALL KUBECTL
# sudo apt-get update && sudo apt-get install -y apt-transport-https
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update
# sudo apt-get install -y kubectl

# #INSTALL MINIKUBE
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.17.1/minikube-linux-amd64 \
#   && chmod +x minikube
# sudo mkdir -p /usr/local/bin/
# sudo install minikube /usr/local/bin/

# #TURN NGINX OFF
# sudo service nginx stop

# #START DOCKER
# sudo groupadd docker
# sudo usermod -a -G docker $USER
# #Restart your session for the changes to be effective

# #RM install files
# rm minikube


# if ! minikube version | grep -i v1.17.1
# then
# 	echo "Installing minikube v1.17.1..."
# 	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.17.1/minikube-linux-amd64 && chmod +x minikube
# 	sudo mkdir -p /usr/local/bin/
# 	sudo install minikube /usr/local/bin/
# else
# 	echo "Looks like minikube v1.17.1 is already installed."
# fi

# if ! kubectl cluster-info
# then
#     echo "Installing kubectl..."
# 	apt-get install kubectl
# fi

sleep 5 &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}"
  sleep .1
done
sleep 5