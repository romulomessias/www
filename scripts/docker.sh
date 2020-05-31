#!/usr/bin/env bash

CONTAINER_NAME=i-build
WORKDIR=/opt/app

CONTAINER_ID=`docker ps --quiet --all --filter name="$CONTAINER_NAME"`

if [ ! -z "$CONTAINER_ID" ]; then
    docker stop   "$CONTAINER_ID";
    docker rm     "$CONTAINER_ID";
    docker rmi -f "$CONTAINER_NAME";
fi

docker build \
    --file      ./scripts/Dockerfile \
    --tag       "$CONTAINER_NAME":latest \
    --build-arg WORKDIR="$WORKDIR" \
    .

docker run \
    --detach \
    --name   "$CONTAINER_NAME" \
    "$CONTAINER_NAME"

rm -f docs/index.html
docker cp \
    "$CONTAINER_NAME":"$WORKDIR"/docs/index.html \
    ./docs/index.html

docker stop "$CONTAINER_NAME"
docker rm   "$CONTAINER_NAME"