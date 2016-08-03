#!/bin/bash
if [[ -e ~/docker/image.tar ]]; then docker load -i ~/docker/image.tar; fi

docker build \
  --tag mttrs-api \
  --file .docker/Dockerfile .

mkdir -p ~/docker; docker save mttrs-api > ~/docker/image.tar
