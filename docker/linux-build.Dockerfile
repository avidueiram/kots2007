FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    make \
    gcc \
    g++ \
    libc6-dev \
    libcurl4-openssl-dev \
    default-libmysqlclient-dev \
    pkg-config \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# The repository is expected to be mounted at /workspace.
# Example:
#   docker run --rm -it -v "$PWD:/workspace" kots2007-linux-build make -C game
CMD ["bash"]
