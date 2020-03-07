FROM confluentinc/cp-base

ARG VERSION
ENV COMPONENT="ccloud"

RUN groupadd -r ccloud && useradd --no-log-init -m -r -g ccloud ccloud

ARG OS=linux
ARG ARCH=amd64
ARG FILE=ccloud_${VERSION}_${OS}_${ARCH}.tar.gz
RUN curl -s https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${VERSION#v}/${FILE} -o ${FILE}
RUN tar -xzvf ${FILE}
RUN mv ccloud/ccloud /usr/bin

COPY include/etc/confluent/docker /etc/confluent/docker

USER ccloud
WORKDIR /home/ccloud

ENTRYPOINT ["/etc/confluent/docker/run"]
