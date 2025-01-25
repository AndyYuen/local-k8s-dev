#! /bin/bash

if [ $#  -ne 2  ]; then
	echo "Usage: $0 clusterName hostIP"
	exit 1
fi

CLUSTER=$1
HOSTIP=$2

# create folders
echo "Creating folders..."
mkdir -p ~/$CLUSTER/data
chmod 777 ~/$CLUSTER/data
mkdir -p ~/$CLUSTER/config
mkdir -p ~/$CLUSTER/manifests

# create image registry
echo "Creating image registry..."
k3d registry create registry.localhost --port 5000
cat << EOF > ~/$CLUSTER/config/registries.yaml
mirrors:
  "localhost:5000":
    endpoint:
      - http://k3d-registry.localhost:5000
EOF

# create k3d cluster with image registry and cater for ingress/load balancer
echo "Creating k3d cluster..."
k3d cluster create ${CLUSTER} --servers 1 --agents 3 \
-v ~/${CLUSTER}/data:/var/lib/rancher/k3s/storage@all \
--k3s-arg "--tls-san=192.168.1.198@server:*" \
--k3s-arg="--disable=traefik@server:*" \
--k3s-arg "--service-node-port-range=30000-30050@server:*" \
--registry-use k3d-registry.localhost:5000 --registry-config ~/${CLUSTER}/config/registries.yaml \
-p "30000-30050:30000-30050@server:0" -p "9000:9000@server:0" \
-p "9090:9090@server:0" -p "80:80@loadbalancer:*" -p "443:443@loadbalancer:*"

# install ingress-nginx
echo "Creating ingress nginx..."
helm upgrade --install --version 4.4.2 ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--namespace ingress-nginx --create-namespace \
--set controller.replicaCount=1 \
--set controller.ingressClassResource.default=true
