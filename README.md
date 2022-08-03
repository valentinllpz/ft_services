# ft_services

This [42](https://42.fr/en/homepage/) project teached us how to build a web platform with multiple services running in different containers orchestrated with [Kubernetes](https://kubernetes.io/fr/). Available features are the following:

- [Kubernetes dashboard](https://kubernetes.io/fr/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [Metal Load Balancer](https://metallb.universe.tf/)
- [Wordpress](https://wordpress.com/) with a [MySQL](https://www.mysql.com/)
- [phpMyAdmin](https://www.phpmyadmin.net/)
- [Nginx](https://www.nginx.com/)
- [VFSTPD](https://doc.ubuntu-fr.org/vsftpd)
- [Grafana](https://grafana.com/) with a [InfluxDB](https://www.influxdata.com/) database

## 🧭 Usage

1. Clone this repo and access it with `cd`
2. Run `./prerequistes.sh` to install everything required to run this project. This may take a while.
3. If anything was installed, you should restart your computer.
4. Run `./setup.sh` to install everything required to run this project. This will take a while.
5. All services addresses and details are available in the info.txt file

## 📚 Ressources

- [Kubernetes 4h video course](https://www.youtube.com/watch?v=X48VuDVv0do&ab_channel=TechWorldwithNana)
- [Docker 3h video course](https://www.youtube.com/watch?v=3c-iBn73dDE&ab_channel=TechWorldwithNana)
- [Kubernetes documentation](https://kubernetes.io/docs/tutorials/)
- [Minikube documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes small guide with examples](https://matthewpalmer.net/kubernetes-app-developer/articles/service-kubernetes-example-tutorial.html)