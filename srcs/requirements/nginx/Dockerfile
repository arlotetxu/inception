FROM alpine:3.23

RUN apk add --no-cache nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY html/ /var/www/html/

EXPOSE 80

ENTRYPOINT ["nginx"]
# CMD ["-V"]
CMD ["-g", "daemon off;"]
