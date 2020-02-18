FROM confluentinc/cp-base

ENV COMPONENT="ccloud"

RUN groupadd -r ccloud && useradd --no-log-init -m -r -g ccloud ccloud

RUN curl -L https://cnfl.io/ccloud-cli | sh -s -- -b /usr/bin

COPY include/etc/confluent/docker /etc/confluent/docker

USER ccloud
WORKDIR /home/ccloud

ENTRYPOINT ["/etc/confluent/docker/run"]
