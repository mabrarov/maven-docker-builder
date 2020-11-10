# Maven Docker Builder

[![License](https://img.shields.io/github/license/mabrarov/maven-docker-builder)](https://github.com/mabrarov/maven-docker-builder/tree/master/LICENSE)
[![Travis CI build status](https://travis-ci.com/mabrarov/maven-docker-builder.svg?branch=master)](https://travis-ci.com/github/mabrarov/maven-docker-builder)

Docker [builder pattern](https://docs.docker.com/develop/develop-images/multistage-build/) implemented with Apache Maven.

## Building

### Building Requirements

1. JDK 1.8+
1. Docker 1.12+
1. If remote Docker instance is used then `DOCKER_HOST` environment variable should point to that
   engine and include the schema, like `tcp://docker-host:2375` instead of `docker-host:2375`.
1. The current directory is directory where this repository is cloned.

### Building Steps

Building with [Maven Wrapper](https://github.com/takari/maven-wrapper):

```bash
./mvnw clean package
```

or on Windows:

```bash
mvnw.cmd clean package
```

## Testing

```bash
docker run --rm abrarov/maven-docker-builder-app:0.0.1 --help
```

Expected output is:

```text
Allowed options:
  --help                             produce help message
  --port arg                         set the TCP port number for incoming
                                     connections' listening
  --session-manager-threads arg (=1) set the number of session manager's
                                     threads
  --session-threads arg (=2)         set the number of sessions' threads
  --stop-timeout arg (=60)           set the server stop timeout at one's
                                     expiration server work will be terminated
                                     (seconds)
  --max-sessions arg (=10000)        set the maximum number of simultaneously
                                     active sessions
  --recycled-sessions arg (=100)     set the maximum number of pooled inactive
                                     sessions
  --address arg (=0.0.0.0)           set the TCP address to listen on (IPv4 or
                                     IPv6)
  --listen-backlog arg (=6)          set the size of TCP listen backlog
  --buffer arg (=4096)               set the session's buffer size (bytes)
  --inactivity-timeout arg           set the timeout at one's expiration
                                     session will be considered as inactive and
                                     will be closed (seconds)
  --max-transfer arg (=4096)         set the maximum size of single async
                                     transfer (bytes)
  --sock-recv-buffer arg             set the size of session's socket receive
                                     buffer (bytes)
  --sock-send-buffer arg             set the size of session's socket send
                                     buffer (bytes)
  --sock-no-delay arg                set TCP_NODELAY option of session's socket
  --demux-per-work-thread arg (=1)   set demultiplexer-per-work-thread mode on
```
