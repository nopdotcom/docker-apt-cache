# Stolen directly from the Docker documentation.
#
# Build: docker build -t apt-cacher .
# Run: docker run -d -p 3142:3142 --name apt-cacher-run apt-cacher
#
# and then you can run containers with:
#   docker run -t -i --rm -e http_proxy http://dockerhost:3142/ debian bash
#
# Here, `dockerhost` is the IP address or FQDN of a host running the Docker daemon
# which acts as an APT proxy server.

FROM   ubuntu:18.04

VOLUME ["/var/cache/apt-cacher-ng"]

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes --no-install-recommends apt-cacher-ng && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3142
CMD    chmod 777 /var/cache/apt-cacher-ng && \
       /etc/init.d/apt-cacher-ng start && \
       tail -f /var/log/apt-cacher-ng/*
