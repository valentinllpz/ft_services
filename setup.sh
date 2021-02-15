printf "\e[1;35m"
printf "# ***************************************************************************************** #\n"
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
printf "# ***************************************************************************************** #\n\n"
printf "\e[0m"

### START MINIKUBE ###
minikube delete
sudo service docker start
minikube start --driver=docker

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
# Wordpress (site): wp_admin / d3BAZnRfNTNydjFjMzUK // wp_user42 / Di8jWyV87eVP3saEV0$ZDNB // wp_user21 / 0VA67AiZXa0Ey5pDaqmFLQ@8
# 