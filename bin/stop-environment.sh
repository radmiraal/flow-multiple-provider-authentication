#!/usr/bin/env bash
source "./.env"

networkPrefix=$(docker-compose ps | grep _ | awk '{print $1}' | head -1 | grep -o '^[^_]*')
networkName="${networkPrefix}_default"

if ! [[ -z $networkPrefix ]]; then
    docker network disconnect ${networkName} dinghy_http_proxy
fi

docker-compose down
