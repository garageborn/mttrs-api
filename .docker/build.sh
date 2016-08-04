#!/bin/bash
# if [[ -e ~/docker/image.tar ]]; then docker load -i ~/docker/image.tar; fi
mkdir -p ~/docker/repo
git clone -b master git@github.com:garageborn/mttrs-api.git ~/docker/repo

docker build \
  --tag mttrs-api \
  --file ~/docker/repo/.docker/Dockerfile .

docker save mttrs-api > ~/docker/image.tar
