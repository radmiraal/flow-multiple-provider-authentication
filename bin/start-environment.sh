#!/usr/bin/env bash
source "./.env"

dockerHost=$(echo ${DOCKER_HOST} | sed -e 's/^[^0-9]*//g' | sed -e 's/\:[0-9]*$//g')

if [ -z ${dockerHost} ]; then
    dockerHost=127.0.0.1
fi

export DOCKERMAINHOST=$dockerHost

proxyRunning=$(docker ps --filter "status=exited" | grep "dinghy_http_proxy" | awk '{print $1}')

if ! [ -z $proxyRunning ]; then
    docker rm dinghy_http_proxy
fi

if ! docker top dinghy_http_proxy &>/dev/null
then
    docker run -d --restart=always -v /var/run/docker.sock:/tmp/docker.sock:ro -p 80:80 -e CONTAINER_NAME=dinghy_http_proxy --name dinghy_http_proxy codekitchen/dinghy-http-proxy
fi

docker-compose up -d

networkPrefix=$(docker-compose ps | grep _ | awk '{print $1}' | head -1 | grep -o '^[^_]*')
networkName="${networkPrefix}_default"

hasNetwork=$(docker inspect dinghy_http_proxy | grep ${networkName})

if [ -z "${hasNetwork}" ]; then
    docker network connect ${networkName} dinghy_http_proxy
fi
