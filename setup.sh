#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
ORANGE='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
NC='\e[0m'
BOLD=$(tput bold)
STD=$(tput sgr0)
flag=0
status=0

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
    i=0
    done
    echo " "
}

function kernel_check {

    KERNEL=$(uname -s)

	if [ $KERNEL != Linux ]
    then
		printf "\u2717  Wrong kernel detected. Trying to run this script on ${RED}${KERNEL}${NC} instead of ${GREEN}Linux${NC}./n"
		exit
	fi

}

function prerequisites_check {

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
    sed -i '0,/flag=1/{s/flag=1/flag=1/}' setup.sh
    printf "${BOLD}\u21BA  Please restart or log out to apply changes. \n${STD}"
    exit

}

function start_minikube {

    sudo service nginx stop
    printf "\u2693  Starting Docker service...\n" && sudo service docker restart
    minikube delete
    if ! minikube start --driver=docker
    then
        exit
    fi
}

function install_metallb {

    printf "\u26FC   Installing Metallb... " ; \
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml > /dev/null 2>&1 ; \
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml > /dev/null 2>&1 ; \
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > /dev/null 2>&1 & spinner

}

function build_images {

    eval $(minikube docker-env)
    echo -e "\u2693  Creating required images with Docker. This may take a while..."
    sleep 5
    printf "    \u2B57  Building the InfluxDB custom image... "
    docker build -t influxdb:latest srcs/influxdb > /dev/null 2>&1 & spinner
    printf "    \u2B57  Building the NGINX custom image... "
    docker build -t nginx:latest srcs/nginx  > /dev/null 2>&1 & spinner
    printf "    \u2B57  Building the MySQL custom image... "
    docker build -t mysql:latest srcs/mysql > /dev/null 2>&1 & spinner
    printf "    \u2B57  Building the phpMyAdmin custom image... "
    docker build -t phpmyadmin:latest srcs/phpmyadmin > /dev/null 2>&1 & spinner
    printf "    \u2B57  Building the WordPress custom image... "
    docker build -t wordpress:latest srcs/wordpress > /dev/null 2>&1 & spinner
    printf "    \u2B57  Building the Grafana custom image... "
    docker build -t grafana:latest srcs/grafana > /dev/null 2>&1 & spinner
    printf "    \u2B57  Building the FTPS custom image... "
    docker build -t ftps:latest srcs/ftps > /dev/null 2>&1 & spinner

}

function apply_yaml_files {

    printf "\u2638   Applying YAML files... "
    kubectl apply -f srcs/metallb.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/nginx.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/mysql-pv.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/mysql.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/telegraf.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/influxdb-pv.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/influxdb.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/phpmyadmin.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/wordpress.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/grafana.yaml > /dev/null 2>&1 ; \
    kubectl apply -f srcs/ftps.yaml > /dev/null 2>&1 & spinner

}

function img_error_check {

    if kubectl get all | grep -i ErrImageNeverPull
    then
        sleep 30
    fi

    if kubectl get all | grep -i ErrImageNeverPull > /dev/null 2>&1
    then
        echo -e "    \u2622  An error occured while building images with Docker. Retrying..."
        eval $(minikube docker-env)
        docker build -t nginx:latest srcs/nginx  > /dev/null
        docker build -t mysql:latest srcs/mysql > /dev/null
        docker build -t phpmyadmin:latest srcs/phpmyadmin > /dev/null
        docker build -t wordpress:latest srcs/wordpress > /dev/null
        docker build -t grafana:latest srcs/grafana > /dev/null
        docker build -t influxdb:latest srcs/influxdb > /dev/null
        docker build -t ftps:latest srcs/ftps > /dev/null
        sleep 30
    fi

    if kubectl get all | grep -i ErrImageNeverPull
    then
        echo -e "${RED}    \u26A0  Failed to build with Docker. Exiting now.${NC}"
        exit
    fi
}

function launch_dashboard {

    printf "\u231B  Waiting for containers to be created... " ; sleep 30 & spinner
    echo ""
    kubectl get all
    echo -e "${BOLD}"
    cat info.txt
    echo -e "${STD}"
    minikube addons enable metrics-server
    minikube dashboard
}

kernel_check
if [ "$flag" = "0" ]
then
    prerequisites_check
fi
start_minikube
install_metallb
build_images
apply_yaml_files
img_error_check
launch_dashboard
