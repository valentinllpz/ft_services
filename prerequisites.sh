#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
NC='\e[0m'
BOLD=$(tput bold)
STD=$(tput sgr0)

printf "${CYAN}"
printf "# ***************************************************************************************** #\n"
printf "#                                                                                           #\n"
printf "#                                                                                           #\n"
printf "#            ::::::: :::                                                                    #\n"
printf "#          :+:      :+:                                       :+:                           #\n"
printf "#         +:+ +:+  +:+ +:+                                                                  #\n"
printf "#        +#+      +#+     +#+#+#+ +#+#+#+ +#+#+#+ +#+   +#+ +#+ +#+#+#+ +#+#+#+ +#+#+#+     #\n"
printf "#       #+#      #+#     #+#+    #+#  +# #+#  #+# #+#  #+# #+# #+#     #+#  +#  #+#+        #\n"
printf "#      #+#      #+#        +#+# #+#     #+#       #+# #+# #+# #+#     #+#         +#+#      #\n"
printf "#     ###      ###     #######  ###### ###         ####  ###  ####### ######  #######       #\n"
printf "#                                                                                           #\n"
printf "#                                                                                           #\n"
printf "#                                                                                           #\n"
printf "# ***************************************************************************************** #\n"
printf "${NC}\n"

KERNEL=$(uname -s)

if [ $KERNEL != Linux ]
then
	printf "\u2717  Wrong kernel detected. Trying to run this script on ${RED}${KERNEL}${NC} instead of ${GREEN}Linux${NC}./n"
	exit
fi

sudo apt-get update > /dev/null 2>&1
if ! docker > /dev/null 2>&1 
then
    printf "\u21E9  Installing Docker... "
    sudo apt-get install docker-ce docker-ce-cli containerd.io > /dev/null 2>&1 & spinner
else
    printf "\u2714  Docker is already installed. \n"
fi

if ! minikube version | grep -i "v1.17.1" > /dev/null 2>&1 
then
    printf "\u21E9  Installing minikube v1.17.1... "
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.17.1/minikube-linux-amd64 > /dev/null 2>&1 ; \
    chmod +x minikube > /dev/null 2>&1 ; \
    sudo mkdir -p /usr/local/bin/ ; \
    sudo install minikube /usr/local/bin/ & spinner
    rm minikube
else
    printf "\u2714  Minikube v1.17.1 is already installed.\n"
fi

if ! kubectl > /dev/null 2>&1 
then
    printf "\u21E9  Installing kubectl... "
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl > /dev/null 2>&1 ; \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl > /dev/null 2>&1 ; \
    chmod +x ./kubectl > /dev/null 2>&1 ; \ 
    sudo mv ./kubectl /usr/local/bin/kubectl & spinner
else
    printf "\u2714  Kubectl is already installed.\n"
fi

sudo usermod -a -G docker "$USER"
printf "${BOLD}\u21BA  Please restart or log out to apply changes. \n${STD}"
exit