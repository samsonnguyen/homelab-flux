#!/bin/bash
# Fetch RKE2 kubeconfig from the server and install it locally

NODE="10.0.10.59"
USER="root"

scp ${USER}@${NODE}:/etc/rancher/rke2/rke2.yaml ~/.kube/config
sed -i '' "s/127.0.0.1/${NODE}/g" ~/.kube/config

echo "Kubeconfig installed. Testing..."
kubectl get nodes
