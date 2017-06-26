# Dockerfile for https://github.com/adnanh/webhook

FROM        golang:1.8.3-alpine3.6 as builder

ENV         GOPATH /go

RUN         apk add --update git build-base; \
            go get -u -v -d github.com/muesli/beehive; \
	          mkdir -p /go/bin; \
	          cd $GOPATH/src/github.com/muesli/beehive; \
	          go build -ldflags="-s -w" -v -o /go/bin/beehive

FROM        alpine:3.6
RUN         apk --no-cache add ca-certificates; \
	          mkdir -p /beehive
WORKDIR     /beehive
COPY        --from=builder /go/bin/beehive .

VOLUME      /conf
EXPOSE      8181

ENTRYPOINT  ["/beehive/beehive"]
CMD         ["-config", "/conf/beehive.conf", "-bind", "0.0.0.0:8181"]
