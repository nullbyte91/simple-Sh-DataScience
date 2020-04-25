FROM tensorflow/tensorflow:latest-gpu-jupyter 
LABEL maintainer="nullbyte.in@gmail.com"

ARG proxy

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN echo "check_certificate = off" >> ~/.wgetrc
RUN echo "[global] \n\
trusted-host = pypi.python.org \n \
\t               pypi.org \n \
\t              files.pythonhosted.org" >> /etc/pip.conf

# >> START Install base software
# Basic update and Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales ca-certificates &&  rm -rf /var/lib/apt/lists/*

# Locale set to something minimal like POSIX
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Exit when RUN get non-zero value
RUN set -e 

# Get basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        git \
        python \
        python-dev \
        python-pip \
        python-wheel \
        python-numpy \
        python3 \
        python3-dev \
        python3-pip \
        python3-wheel \
        python3-numpy \
        python3-setuptools \
        libcurl3-dev  \
        gcc \
        sox \
        libsox-fmt-mp3 \
        htop \
        nano \
        swig \
        cmake \
        libboost-all-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        pkg-config \
        libsox-dev

# Install TF dep
RUN pip install scikit-image keras

