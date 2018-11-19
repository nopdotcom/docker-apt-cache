# An apt-cache, lifted directly from the Docker documentation.
#
# Change CACHE_LOCATION below if you don't like it.
#
# If you're using this during builds:
#
#     docker build --build-args http_proxy=http://172.17.0.1:3142 Dockerfile .
#
# or on Docker for Mac:
#
#     docker build --build-args http_proxy=http://host.docker.internal:3142 Dockerfile .
#
# If you're using this during runs:
#
#     docker run --rm -e http_proxy=http://172.17.0.1:3142 imagename
#
#  Or on Docker for Mac:
#
#     docker run --rm -e http_proxy=http://host.docker.internal:3142 imagename

OS_TEST := $(shell docker system info | grep '^Operating System:' | grep -o 'Mac')

ifneq ($(OS_TEST),Mac)
LISTEN_INTERFACE = 172.17.0.1:
CACHE_LOCATION := /var/cache/docker-apt-cache
else
# Docker for macOS is different.
LISTEN_INTERFACE := 127.0.0.1:
CACHE_LOCATION := /Users/Shared/cache/docker-apt-cache
endif

all: apt_cache

foo:
	echo $(OS_TEST)

apt_cache:
	docker build -t apt_cache .

clean: kill
	-docker rm apt_cache
	-docker rmi apt_cache

run:
	docker run -d --name apt_cache \
		-v $(CACHE_LOCATION):/var/cache/apt-cacher-ng \
		--restart unless-stopped \
		-p $(LISTEN_INTERFACE)3142:3142/tcp apt_cache

kill:
	-docker kill apt_cache
	-docker rm apt_cache
