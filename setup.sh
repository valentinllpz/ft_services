#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
ORANGE='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
NC='\e[0m'
BOLD=$(tput bold)
STD=$(tput sgr0)
flag=1

printf "${MAGENTA}"
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
    printf "\n"
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

    if ! minikube version | grep -i "v1.17.1" > install_logs.txt 2>&1 
    then
        printf "\u21E9  Installing minikube v1.17.1... "
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.17.1/minikube-linux-amd64 > install_logs.txt 2>&1 ; \
        chmod +x minikube > install_logs.txt 2>&1 ; \
        sudo mkdir -p /usr/local/bin/ ; \
        sudo install minikube /usr/local/bin/ & spinner
    else
        printf "\u2714  Minikube v1.17.1 is already installed.\n"
    fi

    if ! kubectl > install_logs.txt 2>&1 
    then
        printf "\u21E9  Installing kubectl... "
        curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl > install_logs.txt 2>&1 ; \
        curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl > install_logs.txt 2>&1 ; \
        chmod +x ./kubectl > install_logs.txt 2>&1 ; \ 
        sudo mv ./kubectl /usr/local/bin/kubectl & spinner
    else
        printf "\u2714  Kubectl is already installed.\n"
    fi

    if ! docker > install_logs.txt 2>&1 
    then
        printf "\u21E9  Installing Docker... "
        sudo apt-get update > install_logs.txt 2>&1 ; \
        sudo apt-get install docker-ce docker-ce-cli containerd.io > install_logs.txt 2>&1 & spinner
    else
        printf "\u2714  Docker is already installed. \n"
    fi

    sudo usermod -a -G docker "$USER"
    sed -i '0,/flag=0/{s/flag=0/flag=1/}' setup.sh
    printf "\u21BA  Please restart or log out to apply changes. \n"
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
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml > install_logs.txt 2>&1 ; \
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > install_logs.txt 2>&1 & spinner

}

function build_images {

    eval $(minikube docker-env)
    echo -e "\u2693  Creating required images with Docker. This may take a while..."
    printf "    \u2B57  Building the NGINX custom image... "
    docker build -t nginx:latest srcs/nginx  > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    \u2622  Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t nginx:latest srcs/nginx 1>/dev/null & spinner
    fi

    printf "    \u2B57  Building the MySQL custom image... "
    docker build -t mysql:latest srcs/mysql > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t mysql:latest srcs/mysql 1> /dev/null & spinner
    fi

    printf "    \u2B57  Building the phpMyAdmin custom image... "
    docker build -t phpmyadmin:latest srcs/phpmyadmin > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t phpmyadmin:latest srcs/phpmyadmin 1> /dev/null & spinner
    fi

    printf "    \u2B57  Building the WordPress custom image... "
    docker build -t wordpress:latest srcs/wordpress > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t wordpress:latest srcs/wordpress 1> install_logs.txt 2>&1 & spinner
    fi

    printf "    \u2B57  Building the Grafana custom image... "
    docker build -t grafana:latest srcs/grafana > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t grafana:latest srcs/grafana 1> /dev/null & spinner
    fi

    printf "    \u2B57  Building the InfluxDB custom image... "
    docker build -t influxdb:latest srcs/influxdb > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t influxdb:latest srcs/influxdb 1> /dev/null & spinner
    fi

    printf "    \u2B57  Building the FTPS custom image... "
    docker build -t ftps:latest srcs/ftps > install_logs.txt 2>&1 & spinner
    if ! [ $? ]
    then
        printf "    Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time.\n"
        sleep 10
        docker build -t ftps:latest srcs/ftps 1> /dev/null & spinner
    fi

}

function apply_yaml_files {

    printf "\u2638  Applying YAML files... "
    kubectl apply -f srcs/metallb.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/nginx.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/mysql-pv.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/mysql.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/telegraf.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/influxdb-pv.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/influxdb.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/phpmyadmin.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/wordpress.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/grafana.yaml > install_logs.txt 2>&1 ; \
    kubectl apply -f srcs/ftps.yaml > install_logs.txt 2>&1 & spinner

}

function launch_dashboard {

    minikube addons enable metrics-server
    minikube dashboard &
    cat info.txt
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
launch_dashboard

# *** Information ************************************************************************* #
#                                                                                           #
# Ftps:				    https://192.168.49.2:21                                             #
#                                                                                           #
#                       ftps_vlugand-		/	ZnRwc0BmdF81M3J2MWMzNQo=                    #
#                                                                                           #
# Grafana:			    https://192.168.49.2:3000                                           #
#                                                                                           #
#                       grafana_vlugand-	/	Z3JhZmFuYUBmdF81M3J2MWMzNQo=                #
#                                                                                           #
# InfluxDB:             metrics_vlugand-	/	bWV0cmljc0BmdF81M3J2MWMzNQo=                #
#                                                                                           #
# PhpMyAdmin:		    https://192.168.49.2:5000 or https://192.168.49.2/phpmyadmin        #
#                                                                                           #
#                       pma_vlugand-		/	cG1hQGZ0XzUzcnYxYzM1Cg==                    #
#                                                                                           #
# Wordpress (site):     https://192.168.49.2:5050 or https://192.168.49.2/phpmyadmin        #
#                                                                                           #
#                       wp_admin			/	5)mHKclP0%Hpz^xV7d                          #
#				    	wp_editor			/	!1J7EGwCvfGpQXO9ZNIeUMz(                    #
#				    	wp_suscriber 		/	0UISwsk!jBz22M7SwJkvBpWp                    #
#                                                                                           #
# Wordpress (MySQL):    wp_vlugand-			/	d3BAZnRfNTNydjFjMzUK                        #
# InfluxDB:             metrics_vlugand-	/	bWV0cmljc0BmdF81M3J2MWMzNQo=                #
#                                                                                           #
# ***************************************************************************************** #