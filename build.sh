#!/bin/bash
ARGO_VERSION=$(cat $(dirname $0)/ARGO_VERSION)
docker build -t busykoala/argo-git-crypt:${ARGO_VERSION} --build-arg ARGO_VERSION=${ARGO_VERSION} .
docker push busykoala/argo-git-crypt:${ARGO_VERSION}
