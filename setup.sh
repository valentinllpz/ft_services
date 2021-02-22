#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
ORANGE='\e[1;33m'
CYAN='\e[1;34m'
MAGENTA='\e[1;35m'
NC='\e[0m'
BOLD=$(tput bold)
STD=$(tput sgr0)
flag=0

echo -e "${CYAN}"
echo -e "# ***************************************************************************************** #"
echo -e "#                                                                                           #"
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
echo -e "#                                                                                           #"
echo -e "# ***************************************************************************************** #\n"
echo -e "${NC}"

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
    if [ $? ]
    then
        echo -e "${BOLD}Failure ${RED}\u2717${NC}${STD}"
    else
        echo -e "${BOLD}Done ${GREEN}\u2714${NC}${STD}"
    fi
}

function kernel_check {

    KERNEL=$(uname -s)

	if [ $KERNEL != Linux ]
    then
		echo -e "${BOLD}\u2717 Wrong kernel detected. Trying to run this script on ${RED}${KERNEL}${NC} instead of ${GREEN}Linux${NC}."
		exit
	fi

}

function prerequisites_check {

    if ! [ minikube version | grep -i v1.17.1 ]
    then
        echo -e "${BOLD}\u21E9 Installing minikube v1.17.1...${STD}"
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.17.1/minikube-linux-amd64 && chmod +x minikube
        sudo mkdir -p /usr/local/bin/
        sudo install minikube /usr/local/bin/
    else
        echo -e "${BOLD}\u2714 Minikube v1.17.1 is already installed.${STD}"
    fi

    if ! [ kubectl cluster-info ]
    then
        echo "${BOLD}\u21E9 Installing kubectl...${STD}"
        sudo apt-get update && sudo apt-get install kubectl
    else
        echo -e "${BOLD}\u2714 Kubectl is already installed.${STD}"
    fi

    if ! [ docker ]
    then
        echo -e "${BOLD}\u21E9 Installing Docker...${STD}"
        sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io
    else
        echo -e "${BOLD}\u2714 Docker is already installed.${STD}"
    fi

    sudo -a -G docker "$USER"
    sed -i "s/flag=0/flag=1/" setup.sh
    echo -e "${BOLD}\u21BA You may need to restart to apply changes.${STD}"
    exit

}

function start_minikube {

    sudo service nginx stop
    sudo service docker restart & echo -e "${BOLD}\u1F433 Starting Docker service... ${STD}" & spinner
    minikube delete
    minikube start --driver=docker

}

function install_metallb {

    echo -e "${BOLD}\u26FC Installing Metallb... ${STD}"
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml ; \
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml ; \
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > /dev/null/ 2>&1 & spinner

}

function build_images {

    eval $(minikube docker-env)

    echo -e "${BOLD}Building the NGINX custom image... ${STD}"
    docker build -t nginx:latest srcs/nginx > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t nginx:latest srcs/nginx 1>/dev/null/ & spinner
    fi

    echo -e "${BOLD}Building the MySQL custom image... ${STD}"
    docker build -t mysql:latest srcs/mysql > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t mysql:latest srcs/mysql 1> /dev/null/ & spinner
    fi

    echo -e "${BOLD}Building the phpMyAdmin custom image... ${STD}"
    docker build -t phpmyadmin:latest srcs/phpmyadmin > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t phpmyadmin:latest srcs/phpmyadmin 1> /dev/null/ & spinner
    fi

    echo -e "${BOLD}Building the WordPress custom image... ${STD}"
    docker build -t wordpress:latest srcs/wordpress > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t wordpress:latest srcs/wordpress 1> /dev/null/ 2>&1 & spinner
    fi

    echo -e "${BOLD}Building the Grafana custom image... ${STD}"
    docker build -t grafana:latest srcs/grafana > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t grafana:latest srcs/grafana 1> /dev/null/ & spinner
    fi

    echo -e "${BOLD}Building the InfluxDB custom image... ${STD}"
    docker build -t influxdb:latest srcs/influxdb > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t influxdb:latest srcs/influxdb 1> /dev/null/ & spinner
    fi

    echo -e "${BOLD}Building the FTPS custom image... ${STD}"
    docker build -t ftps:latest srcs/ftps > /dev/null/ 2>&1 & spinner
    if [ $? ]
    then
        echo -e "\u2622 Don't panic, this might be a temporary error. Retrying in a few seconds, stderr will be printed this time."
        sleep 10
        docker build -t ftps:latest srcs/ftps 1> /dev/null/ & spinner
    fi

}
function apply_yaml_files {

    echo -e "${BOLD}\u2638 Applying YAML files... ${STD}"
    kubectl apply -f srcs/metallb.yaml ; \
    kubectl apply -f srcs/nginx.yaml ; \
    kubectl apply -f srcs/mysql-pv.yaml ; \
    kubectl apply -f srcs/mysql.yaml ; \
    kubectl apply -f srcs/telegraf.yaml ; \
    kubectl apply -f srcs/influxdb-pv.yaml ; \
    kubectl apply -f srcs/influxdb.yaml ; \
    kubectl apply -f srcs/phpmyadmin.yaml ; \
    kubectl apply -f srcs/wordpress.yaml ; \
    kubectl apply -f srcs/grafana.yaml ; \
    kubectl apply -f srcs/ftps.yaml & spinner

}

function launch_dashboard {

    minikube addons enable metrics-server
    minikube dashboard &

}

kernel_check
if ! [ "$flag" = "0" ]
then
    prerequisites_check
fi
start_minikube
install_metallb
build_images
apply_yaml_files
launch_dashboard

### ID / MDP:
# Ftps:				ftps_vlugand-		/	ZnRwc0BmdF81M3J2MWMzNQo=
# Grafana:			grafana_vlugand-	/	Z3JhZmFuYUBmdF81M3J2MWMzNQo=
# InfluxDB:			metrics_vlugand-	/	bWV0cmljc0BmdF81M3J2MWMzNQo=
# PhpMyAdmin:		pma_vlugand-		/	cG1hQGZ0XzUzcnYxYzM1Cg==		
# Wordpress (site): wp_admin			/	5)mHKclP0%Hpz^xV7d 
#					wp_editor			/	!1J7EGwCvfGpQXO9ZNIeUMz( 
#					wp_suscriber 		/	0UISwsk!jBz22M7SwJkvBpWp
# Wordpress (DB):   wp_vlugand-			/	d3BAZnRfNTNydjFjMzUK
