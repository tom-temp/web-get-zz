FROM cloudreve/cloudreve:latest
ENV TZ=Asia/Shanghai
# RUN echo 'nameserver 223.5.5.5'
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache ca-certificates curl unzip nginx gettext # --virtual .build-deps 

# v2ray
# RUN rm -rf /tmp/v2ray
WORKDIR /tmp/v2ray
RUN curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray && \
    install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray && \
    install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl && \
    rm -rf /tmp/v2ray && \
    install -d /usr/local/etc/v2ray

# WORKDIR /tmp/zpan
# RUN curl -L -H "Cache-Control: no-cache" -o /tmp/zpan/zpan.zip https://github.com/saltbo/zpan/releases/latest/download/zpan-linux-amd64.tar.gz && \
#     tar -xf /tmp/zpan/zpan.zip -C /tmp/zpan && \
#     install -m 755 /tmp/zpan/zpan-*/bin/zpan /usr/local/bin/zpan && \
#     rm -rf /tmp/zpan && \
#     install -d /usr/local/etc/zpan
# 放弃zpan，无法在alpine中使用

# nginx
COPY nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY cloudever_config/conf.ini /cloudreve/conf.ini


COPY configure.sh /configure.sh
COPY v2ray_config /
RUN chmod +x /configure.sh

WORKDIR /

ENTRYPOINT ["sh", "/configure.sh"]

