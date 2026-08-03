FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    CC=gcc \
    CFLAGS="-std=gnu11 -D_GNU_SOURCE -Wall -Wextra -Wpedantic -O0 -g"

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
       binutils \
       build-essential \
       ca-certificates \
       file \
       gdb \
       git \
       iproute2 \
       make \
       procps \
       strace \
       valgrind \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/inclass
COPY . /workspace/inclass
CMD ["make", "smoke"]
