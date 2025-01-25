#! /bin/bash

if [ $#  -ne 1  ]; then
	echo "Usage: $0 namespace"
	exit 1
fi

NAMESPACE=$1

echo "Creating namespace: ${NAMESPACE}..."
kubectl create ns ${NAMESPACE}

echo "Setting default namespace to ${NAMESPACE}..."
kubectl config set-context --current --namespace=${NAMESPACE}