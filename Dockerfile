FROM --platform=linux/arm/v7 debian:buster
SHELL ["/bin/bash", "-c"]
WORKDIR /

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
                        Dpkg::Options::="--force-confnew" \
                        gnupg build-essential gettext \
                        libyaml-cpp-dev lsb-release isc-dhcp-server \
                        tk-dev libncurses5-dev libncursesw5-dev \
                        libreadline6-dev libdb5.3-dev libgdbm-dev \
                        libsqlite3-dev libssl-dev libbz2-dev \
                        libexpat1-dev liblzma-dev zlib1g-dev libffi-dev file \
                        wget ca-certificates ntpdate curl libssl-dev git && \
                      rm -rf /var/lib/apt/lists/*

RUN git clone http://checkinstall.izto.org/checkinstall.git && cd checkinstall && make && make install

RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tar.xz && \
        tar xf Python-3.8.0.tar.xz && \
        cd Python-3.8.0 && \
        ./configure --enable-optimizations --prefix=/usr && \
        make -j 4 && \
        checkinstall -D --fstrans=no --pkgname=python3 -y make altinstall \
        dpkg -i python3*.deb



RUN wget https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0.tar.gz && \
        tar -xzf cmake-3.21.0.tar.gz && \
        cd cmake-3.21.0 && \
        ./bootstrap --parallel=6 --prefix=/usr -- -D_FILE_OFFSET_BITS=64 && \
        make -j 6 && \
        ./bin/cpack -G DEB && \
        dpkg -i cmake*.deb && \
        cd / && rm -rf cmake-3.21.0*
