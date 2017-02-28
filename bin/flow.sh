#!/usr/bin/env bash
if [ "${FLOW_CONTEXT}" == "Development/Brew" ]; then
    ./flow $@
else
    source "./.env"
    docker-compose exec --user=1000:33 php php flow $@
fi
