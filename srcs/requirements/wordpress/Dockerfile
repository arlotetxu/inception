FROM alpine:3.23

RUN apk add --no-cache php85 php85-fpm \
	mariadb-client curl && \
	curl -fsSL -o /usr/local/bin/wp \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp && \
	mkdir -p /var/www/html

COPY conf/zz-docker.conf /etc/php85/php-fpm.d/zz-docker.conf
COPY --chmod=755 tools/entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["php-fpm85", "-F"]

