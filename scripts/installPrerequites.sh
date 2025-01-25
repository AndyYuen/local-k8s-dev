#! /bin/bash

COUNT=32

printf "\n\n"
printf "=%.0s"  $(seq 1 $COUNT)

# install docker
docker version | grep "Docker Engine" > /dev/null
if [ $?  -ne 0  ]; then
    echo "Installing docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo "Docker already installed."
fi
docker version
printf "\n\n"
printf "=%.0s"  $(seq 1 $COUNT)

# install k3d
k3d version | grep "k3d version" > /dev/null
if [ $?  -ne 0  ]; then
    echo "Installing k3d..."
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.8.1 bash
else
    echo "k3d already installed."
fi
k3d version | grep "k3d version" 
printf "\n\n"
printf "=%.0s"  $(seq 1 $COUNT)

# install helm
helm version | grep "version" > /dev/null
if [ $?  -ne 0  ]; then
    echo "Installing helm..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
else
    echo "helm already installed."
fi
helm version | grep "version"
printf "\n\n"
printf "=%.0s"  $(seq 1 $COUNT)

# install kubectl
kubectl version -o yaml --client=true | grep "Version" > /dev/null
if [ $?  -ne 0  ]; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
    echo "kubectl already installed."
fi
kubectl version -o yaml --client=true
printf "\n\n"
printf "=%.0s"  $(seq 1 $COUNT)
printf "\n\n"