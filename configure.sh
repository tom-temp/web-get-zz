#!/bin/sh
# V2Ray generate configuration
# Download and install V2Ray
# export PROTOCOL=vmess
# export UUID=da311aae-045f-4bf8-b73a-2227d336021a
# export WS_PATH=112233
# export PORT=1234
config_path=$PROTOCOL"_ws_tls.json"
envsubst '\$UUID,\$WS_PATH' < /$config_path > /usr/local/etc/v2ray/config.json
# Run cloudflare
/cloudreve/cloudreve --c /cloudreve/conf.ini &
# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json &
# Run nginx
/bin/ash -c "envsubst '\$PORT,\$WS_PATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'
