# Freifunk Augsburg Docker build image
Docker image to build firmware images for Freifunk Augsburg (https:augsburg.freifunk.net)

## Prequistories: How to install Docker (for Ubuntu)
Follow the Howto from Docker: (https://docs.docker.com/engine/install/ubuntu/)

    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent \
     software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
     sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] \
     https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io

This Docker image is a first try to ease setting up a fully working build environment for gluon based firmwares with the new bable-based routing algorithm. The build process is started automatically when the container is run. There is no need to manually run commands inside the container anymore.

## Setting up a docker environment for automatised build process
Clone repository:

    git clone https://github.com/freifunk-augsburg/gluon-docker.git
    cd gluon-Docker

Use the following commands on the host to create and run the docker image:

    docker build -t ffa-v2020.0.1 .
    docker run -it --name ffa ffa-v2020.0.1

The container will automatically start the firmware build process.

We highly suggest adding some parameters to bind the directories `firmware` and `openwrt_build` in the current working directory to the container's output directories

    docker run -it --name ffa \
      -v "$(pwd)/firmwares:/gluon/output" \
      -v "$(pwd)/openwrt_build:/gluon/openwrt/build_dir" \
      ffa-v2020.0.1

You can run a shell in an existing container with the following command:

    docker exec -it ffa /bin/bash

To restart the image once it has been stopped:

    docker start -i ffa

Once you are done, container and image can be deleted by calling

    docker rm ffa
    docker rmi ffa-v2020.0.1
