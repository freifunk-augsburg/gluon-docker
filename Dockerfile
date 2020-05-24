FROM gcc:7.2

##_ Steini 06.05.2020 - Anpassungen fuer die Forkisierung
#ARG FFMD_REPO=https://github.com/FreifunkMD/site-ffmd.git
#ARG FFMD_VERSION=tags/v0.40
#ARG GLUON_REPO=git://github.com/freifunk-gluon/gluon.git
#ARG GLUON_VERSION=origin/v2016.2.x
ARG FFMD_REPO=https://github.com/FreifunkMD/site-ffmd.git
ARG FFMD_BRANCH=babel
ARG GLUON_REPO=https://github.com/christf/gluon.git
ARG GLUON_BRANCH=christf_next


# Apt-proxy config
COPY detect-apt-proxy.sh /usr/local/bin/
COPY 01proxy /etc/apt/apt.conf.d

# Update & install packages & cleanup afterwards
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        build-essential \
        ecdsautils \
        gawk \
        git \
        libncurses-dev \
        libssl-dev \
        libz-dev \
        python-pip \
        python3-pip \
        subversion \
        unzip \
        wget && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN git clone -b $GLUON_BRANCH $GLUON_REPO gluon 
WORKDIR gluon

RUN git clone -b $FFMD_BRANCH $FFMD_REPO site
WORKDIR site

WORKDIR /gluon
RUN pwd

# RUN make update

ENV FORCE_UNSAFE_CONFIGURE=1

ENTRYPOINT ["/bin/bash","-c"]
CMD ["cd /gluon && make update && for i in ar71xx-generic ar71xx-tiny; do GLUON_TARGET=$i make -j2 || make V=s && break; done"]
##_ Steini CMD ["cd /gluon && make update && site/build.sh -y"]
