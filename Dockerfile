FROM alpine:3.12.1

RUN apk add curl
RUN curl -L --http1.1 https://cnfl.io/ccloud-cli | sh -s -- -b /usr/bin

ENTRYPOINT ["/usr/bin/ccloud"]
