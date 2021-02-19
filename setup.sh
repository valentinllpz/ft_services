#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
ORANGE='\e[1;33m'
CYAN='\e[1;34m'
MAGENTA='\e[1;35m'
NC='\e[0m'
BOLD=$(tput bold)
STD=$(tput sgr0)

echo -e "${CYAN}"
echo -e "# ***************************************************************************************** #"
echo -e "#                                                                                           #"
echo -e "#            ::::::: :::                                                                    #"
echo -e "#          :+:      :+:                                       :+:                           #"
echo -e "#         +:+ +:+  +:+ +:+                                                                  #"
echo -e "#        +#+      +#+     +#+#+#+ +#+#+#+ +#+#+#+ +#+   +#+ +#+ +#+#+#+ +#+#+#+ +#+#+#+     #"
echo -e "#       #+#      #+#     #+#+    #+#  +# #+#  #+# #+#  #+# #+# #+#     #+#  +#  #+#+        #"
echo -e "#      #+#      #+#        +#+# #+#     #+#       #+# #+# #+# #+#     #+#         +#+#      #"
echo -e "#     ###      ###     #######  ###### ###         ####  ###  ####### ######  #######       #"
echo -e "#                                                                                           #"
echo -e "#                                                                                           #"
echo -e "# ***************************************************************************************** #\n"
echo -e "${NC}"

function loading_animation {

    pid=$! # Process Id of the previous running command

    spin='-\|/'

    i=0
    while kill -0 $pid 2>/dev/null
    do
    i=$(( (i+1) %4 ))
    printf "\r${spin:$i:1}"
    sleep .1
    done

}

function prerequisites_check {

    KERNEL=$(uname -s)
	if  $KERNEL != Linux
    then
		echo -e "Wrong kernel detected. Trying to run this script on ${RED}${KERNEL}${NC} instead of ${GREEN}Linux${NC}."
		exit
	fi

    if ! minikube version | grep -i v1.17.1
    then
        echo -e "${BOLD}Installing minikube v1.17.1...${STD}"
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.17.1/minikube-linux-amd64 && chmod +x minikube
        sudo mkdir -p /usr/local/bin/
        sudo install minikube /usr/local/bin/
    else
        echo -e "${BOLD}Minikube v1.17.1 is already installed. ${GREEN}✅${NC}${STD}"
    fi

    if ! kubectl cluster-info
    then
        echo "${BOLD}Installing kubectl...${STD}"
        sudo apt-get update && sudo apt-get install kubectl
    else
        echo -e "${BOLD}Kubectl is already installed. ${GREEN}✅${NC}${STD}"
    fi

    if ! docker
    then
        echo "${BOLD}Installing Docker...${STD}"
        sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io
    else
        echo -e "${BOLD}Docker is already installed.${STD}"
    fi

}

sudo service docker restart

### START MINIKUBE ###
function start_minikube {
    minikube delete
    minikube start --driver=docker
}

### METALLB INSTALLATION ###
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

### PREPARING DOCKER IMAGES ###
eval $(minikube docker-env)
docker build -t nginx:latest srcs/nginx
docker build -t mysql:latest srcs/mysql
docker build -t phpmyadmin:latest srcs/phpmyadmin
docker build -t wordpress:latest srcs/wordpress
docker build -t grafana:latest srcs/grafana
docker build -t influxdb:latest srcs/influxdb
docker build -t ftps:latest srcs/ftps

### DEPLOYING WITH YAML CONF FILES ###
kubectl apply -f srcs/metallb.yaml
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/mysql-pv.yaml
kubectl apply -f srcs/mysql.yaml
kubectl apply -f srcs/telegraf.yaml
kubectl apply -f srcs/influxdb-pv.yaml
kubectl apply -f srcs/influxdb.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/wordpress.yaml
kubectl apply -f srcs/grafana.yaml
kubectl apply -f srcs/ftps.yaml

minikube addons enable metrics-server
minikube dashboard

#### faire des if pour verifier que pas d'erreur de build sinon retry. 
### ID / MDP:
# Ftps:				ftps_vlugand-		/	ZnRwc0BmdF81M3J2MWMzNQo=
# Grafana:			grafana_vlugand-	/	Z3JhZmFuYUBmdF81M3J2MWMzNQo=
# InfluxDB:			metrics_vlugand-	/	bWV0cmljc0BmdF81M3J2MWMzNQo=
# PhpMyAdmin:		pma_vlugand-		/	cG1hQGZ0XzUzcnYxYzM1Cg==		
# Wordpress (site): wp_admin			/	5)mHKclP0%Hpz^xV7d 
#					wp_editor			/	!1J7EGwCvfGpQXO9ZNIeUMz( 
#					wp_suscriber 		/	0UISwsk!jBz22M7SwJkvBpWp
# Wordpress (DB):   wp_vlugand-			/	d3BAZnRfNTNydjFjMzUK
