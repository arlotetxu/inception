FROM alpine:3.23

RUN apk update && apk add nginx
RUN apk add openssl curl ca-certificates
RUN apk add vim

#COPY

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
