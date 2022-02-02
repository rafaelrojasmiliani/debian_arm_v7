FROM --platform=linux/arm/v7 debian:buster
SHELL ["/bin/bash", "-c"]
WORKDIR /

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
                        gnupg python3 python3-dev python3-pip build-essential \
                        libyaml-cpp-dev lsb-release isc-dhcp-server \
                        wget ca-certificates ntpdate curl libssl-dev


RUN wget https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0.tar.gz && \
        tar -xzf cmake-3.21.0.tar.gz && \
        cd cmake-3.21.0 && \
        ./bootstrap --parallel=6 --prefix=/usr -- -D_FILE_OFFSET_BITS=64 && \
        make -j 6 && \
        ./bin/cpack -G DEB && \
        dpkg -i cmake*.deb
