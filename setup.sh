### START MINIKUBE ###
#minikube start 

### METALLB INSTALLATION ###
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
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

### DEPLOYING WITH YAML CONF FILES ###
kubectl apply -f srcs/metallb.yaml
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/mysql-pv.yaml
kubectl apply -f srcs/mysql.yaml
#kubectl apply -f srcs/telegraf.yaml
kubectl apply -f srcs/influxdb-pv.yaml
kubectl apply -f srcs/influxdb.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/wordpress.yaml
kubectl apply -f srcs/grafana.yaml