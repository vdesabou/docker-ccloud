# docker-ccloud [![Build Status](https://travis-ci.com/vdesabou/docker-ccloud.svg?branch=master)](https://travis-ci.com/vdesabou/docker-ccloud)

Docker image of Confluent's `ccloud` CLI: [docs](https://docs.confluent.io/current/cloud/using/index.html#ccloud-cli)

## Usage

To use this image, pull from [Docker Hub](https://hub.docker.com/repository/docker/vdesabou/docker-ccloud), run the following command:

```bash
$ docker pull vdesabou/docker-ccloud:latest
```

Verify the install

```bash
$ docker run -ti vdesabou/docker-ccloud:latest version

Version:     v1.20.1
Git Ref:     d62e7690
Build Date:  2020-11-06T03:13:41Z
Go Version:  go1.14.7 (linux/amd64)
Development: false
```

Then, authenticate by running:

```bash
$ docker run -ti -v /root --name ccloud-config vdesabou/docker-ccloud:latest login
```

Once you authenticate successfully, credentials are preserved in the volume of the ccloud-config container.

To run ccloud commands using these credentials, run the container with `--volumes-from ccloud-config`:

Exemple:

```bash
$ docker run -ti --volumes-from ccloud-config vdesabou/docker-ccloud:latest kafka cluster list
```

:warning: Warning: The `ccloud-config` container now has a volume containing your Confluent Cloud credentials.

Once you're done, you can remove `ccloud-config` container:

```bash
$ docker rm -f ccloud-config
```