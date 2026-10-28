FROM alpine:3.23

RUN apk add --no-cache redis

COPY conf/redis.conf etc/redis.conf
COPY --chmod=755  tools/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 6379

#CMD ["redis-server", "/etc/redis.conf"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
