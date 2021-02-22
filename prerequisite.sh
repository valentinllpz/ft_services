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


function spinner {

    char=(\| / – \\)
    delay=0.1
    pid=$!
    i=0

    while kill -0 $pid 2>/dev/null; do

        for ((i=0; i<=3; i++)); do
            echo -n ${char[$i]}
            sleep $delay
            echo -ne '\b'
        done

    i=0;
    done
    if ! [ $? ]
    then
        echo -e "${BOLD}Done ${GREEN}\u2714${NC}${STD}"
    else
        echo -e "${BOLD}Failure ${RED}\u2717${NC}${STD}"
    fi
}


find -rew yrtje & spinner