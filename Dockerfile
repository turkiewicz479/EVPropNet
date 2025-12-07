FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    pkg-config \
    libjpeg-dev \
    libpng-dev \
    libgl1 \
    python3.6 \
    python3.6-dev \
    python3-pip \
    python3-setuptools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
RUN python3 -m pip install --upgrade pip

RUN pip3 install --no-cache-dir \
    tensorflow==1.14.0 \
    opencv-python==3.4.18.65 \
    matplotlib \
    tqdm \
    numpy \
    termcolor \
    scikit-image

WORKDIR /app

CMD ["bash"]