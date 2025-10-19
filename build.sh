#!/bin/bash

# Build script for docker image
# Usage: ./build.sh [registry] [image_name] [tag]

IMAGE_REG=${1:-docker.io/mohanty2003}
IMAGE_NAME=${2:-sre-ci-cd-sample}
IMAGE_TAG=${3:-latest}

echo "Building docker image..."
docker build -t ${IMAGE_REG}/${IMAGE_NAME}:${IMAGE_TAG} .
echo "Build complete!"
echo "Image: ${IMAGE_REG}/${IMAGE_NAME}:${IMAGE_TAG}"