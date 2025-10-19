#!/bin/bash

# Deploy to kubernetes
# Usage: ./deploy.sh [kubeconfig] [namespace] [registry] [image_name] [tag]

KUBECONFIG_FILE=${1:-~/.kube/config}
K8S_NAMESPACE=${2:-dev}
IMAGE_REG=${3:-docker.io/mohanty2003}
IMAGE_NAME=${4:-sre-ci-cd-sample}
IMAGE_TAG=${5:-latest}

export KUBECONFIG=${KUBECONFIG_FILE}

echo "Deploying to kubernetes..."
kubectl apply -f k8s/
kubectl set image deployment/sre-ci-cd-deployment sre-ci-cd-container=${IMAGE_REG}/${IMAGE_NAME}:${IMAGE_TAG} -n ${K8S_NAMESPACE}
kubectl rollout status deployment/sre-ci-cd-deployment -n ${K8S_NAMESPACE}
echo "Deployment complete!"
