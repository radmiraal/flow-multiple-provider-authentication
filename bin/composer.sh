#!/usr/bin/env bash
source "./.env"

if [ -f "Configuration/PackageStates.php" ]; then
    rm -rf Configuration/PackageStates.php
fi

composer --version >> /dev/null 2>&1
if [ $? -eq 0 ]; then
    arguments=$@

    if [ "${1}" == "install" ] || [ "${1}" == "update" ]; then
        arguments=("--ignore-platform-reqs" "${arguments[@]}")
    fi

    command="composer --ansi ${arguments[@]}"
    exec $command
else
   mkdir -p ~/.composer
    mkdir -p ~/.gnupg

    if ! [ -f ~/.gitconfig ]; then
        touch ~/.gitconfig
    fi

    docker run -it --rm \
        --network host \
        --env-file ./.env \
        -e "LOCAL_USER_ID=$(id -u)" \
        -e "LOCAL_GROUP_ID=$(id -g)" \
        -v "$(pwd):/app" \
        -v "$(echo ~)/.gitconfig:/home/docker/.gitconfig" \
        -v "$(echo ~)/.gnupg:/home/docker/.gnupg" \
        -v "$(echo ~)/.composer/:/home/docker/.composer" \
        simplyadmire/composer:1.2 \
        $@
fi
