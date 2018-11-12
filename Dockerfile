FROM golang:1.11.2-alpine3.8 AS build
ARG SERVICE
RUN apk update && apk add git gcc make musl-dev
ADD . /go/src/github.com/${ORG}/${SERVICE}
WORKDIR /go/src/github.com/${ORG}/${SERVICE}
RUN make clean install test build
RUN mv build/${SERVICE} /${SERVICE} 

FROM alpine:3.8
ARG SERVICE
ENV APP=${SERVICE}
RUN mkdir /app
COPY --from=build /${SERVICE} /app/${SERVICE}
ENTRYPOINT exec /app/${APP}
