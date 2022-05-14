FROM nginx:1.19.3-alpine
ENV TZ=Asia/Shanghai
RUN apk add --no-cache --virtual .build-deps ca-certificates bash curl unzip

# v2ray
WORKDIR /tmp/v2ray
RUN curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip \
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray \
    install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray \
    install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl \
    rm -rf /tmp/v2ray \
    install -d /usr/local/etc/v2ray

# nginx
COPY nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx/nginx.conf /etc/nginx/nginx.conf


COPY configure.sh /configure.sh
COPY v2ray_config /
RUN chmod +x /configure.sh

ENTRYPOINT ["sh", "/configure.sh"]

