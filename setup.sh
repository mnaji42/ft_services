# Installer Minikube a 42:
#      brew install minikube
#      mkdir /goinfre/$USER;mkdir /goinfre/$USER/.minikube;ln -s /goinfre/$USER/.minikube ~/.minikube
# add in .zshrc :
#      [ -d /goinfre/$USER ] || mkdir /goinfre/$USER
#      [ -d /goinfre/$USER/.minikube ] || mkdir /goinfre/$USER/.minikube

if ! which docker >/dev/null 2>&1
then
    sh srcs/42toolbox/init_docker.sh
fi

if ! which minikube >/dev/null 2>&1
then
    echo Please Install Minikube
fi

if [ "$1" = "minik" ]
then
    if ! minikube start --vm-driver=virtualbox \
        --cpus 3 --disk-size=30000mb --memory=3000mb
    then
        echo Cannot start minikube!
        exit 1
    fi
    minikube addons enable metrics-server
    minikube addons enable ingress
fi

if [ "$1" = "clean" ] || [ "$1" = "fclean" ]
then
    kubectl delete -k srcs
    if [ "$1" = "fclean" ]
    then
        kubectl delete nodes minikube
    fi
    exit 0
fi

MINIKUBE_IP=$(minikube ip)

eval $(minikube docker-env)

docker build -t img-nginx srcs/nginx
docker build -t img-ftps srcs/ftps
docker build -t img-wordpress srcs/wordpress
docker build -t img-phpmyadmin srcs/phpmyadmin
docker build -t img-grafana srcs/grafana
docker build -t img-mysql srcs/mysql

kubectl apply -k srcs