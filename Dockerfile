FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="christof.torres@tecnico.ulisboa.pt"

SHELL ["/bin/bash", "-c"]
RUN apt-get update -q && \
    apt-get install -y wget unzip pandoc git build-essential software-properties-common iputils-ping && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Install Soufflé
RUN apt-get update -q && \
    apt-get install -y bison clang cmake doxygen flex g++ libffi-dev libncurses5-dev libsqlite3-dev make mcpp sqlite3 zlib1g-dev && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/souffle-lang/souffle/archive/refs/tags/2.5.zip && \
    unzip 2.5.zip && \
    cd souffle-2.5 && \
    cmake -S . -B build && \
    cmake --build build -j8 && \
    mv build/src/souffle /usr/local/bin && \
    cd .. && \
    rm -rf souffle-2.5 && \
    rm -rf 2.5.zip

# Install Python3 & Python Dependencies
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update -q && \
    apt install -y python3 python3-pip && \
    apt-get clean -q && rm -rf /var/lib/apt/lists/*
COPY horus horus
RUN cd horus && pip3 install -r requirements.txt --break-system-packages

WORKDIR /root/horus
ENTRYPOINT ["python3", "horus.py"]
CMD ["--help"]