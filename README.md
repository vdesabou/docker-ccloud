# docker-ccloud [![Build Status](https://travis-ci.com/vdesabou/docker-ccloud.svg?branch=master)](https://travis-ci.com/vdesabou/docker-ccloud)

Docker image of Confluent's `ccloud` CLI: [docs](https://docs.confluent.io/current/cloud/using/index.html#ccloud-cli)

## Usage

To use this image, pull from [Docker Hub](https://hub.docker.com/repository/docker/vdesabou/docker-ccloud), run the following command:

```bash
$ docker pull vdesabou/docker-ccloud:latest
```

Verify the install

```bash
$ docker run -ti -e "CCLOUD_BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS" -e "CCLOUD_API_KEY=$CCLOUD_API_KEY" -e "CCLOUD_API_SECRET=$CCLOUD_API_SECRET" vdesabou/docker-ccloud:latest ccloud version

Version:     v0.239.0
Git Ref:     5c56da5
Build Date:  2020-02-14T00:56:39Z
Build Host:  david.hyde@David-Hydes-MBP15.local
Go Version:  go1.12.5 (linux/amd64)
Development: false
```

or use a particular version number:

```bash
$ docker run -ti -e "CCLOUD_BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS" -e "CCLOUD_API_KEY=$CCLOUD_API_KEY" -e "CCLOUD_API_SECRET=$CCLOUD_API_SECRET" vdesabou/docker-ccloud:v0.239.0 ccloud version

Version:     v0.239.0
Git Ref:     5c56da5
Build Date:  2020-02-14T00:56:39Z
Build Host:  david.hyde@David-Hydes-MBP15.local
Go Version:  go1.12.5 (linux/amd64)
Development: false
```

Then, authenticate by running:

```bash
$ docker run -ti -e "CCLOUD_BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS" -e "CCLOUD_API_KEY=$CCLOUD_API_KEY" -e "CCLOUD_API_SECRET=$CCLOUD_API_SECRET" -v /home/ccloud/ --name ccloud-config vdesabou/docker-ccloud:latest ccloud login
```

Once you authenticate successfully, credentials are preserved in the volume of the ccloud-config container.

To run ccloud commands using these credentials, run the container with `--volumes-from ccloud-config`:

Exemple:

```bash
$ docker run -ti -e "CCLOUD_BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS" -e "CCLOUD_API_KEY=$CCLOUD_API_KEY" -e "CCLOUD_API_SECRET=$CCLOUD_API_SECRET" --volumes-from ccloud-config vdesabou/docker-ccloud ccloud kafka cluster list
```

:warning: Warning: The `ccloud-config` container now has a volume containing your Confluent Cloud credentials.

Once you're done, you can remove `ccloud-config` container:

```bash
$ docker rm -f ccloud-config
```