#!/bin/bash
if [[ -e ~/docker/image.tar ]]; then docker load -i ~/docker/image.tar; fi

docker build \
  --build-arg DATABASE_URL=$DATABASE_URL \
  --tag mttrs-api \
  --file .docker/Dockerfile .

mkdir -p ~/docker; docker save mttrs-api > ~/docker/image.tar
