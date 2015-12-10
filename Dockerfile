FROM debian:latest
RUN apt-get update && \
    apt-get install -y \
        build-essential pkg-config libgtest-dev libc6-dev m4 \
        g++-multilib autoconf libtool ncurses-dev unzip git python \
        zlib1g-dev wget bsdmainutils
COPY ./zerocashd/ ./zerocashd/
WORKDIR ./zerocashd
RUN ./zcutil/build.sh
CMD ./qa/zerocash/full-test-suite.sh
