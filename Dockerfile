FROM alpine:latest

ARG GOST_VERSION=2.12.0
ARG CADDY_VERSION=2.7.6

RUN apk add --no-cache wget tar ca-certificates

# ===== 安装 gost =====
RUN wget https://github.com/ginuerzh/gost/releases/download/v${GOST_VERSION}/gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    tar -xzf gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    mv gost /usr/bin/gost && \
    chmod +x /usr/bin/gost && \
    rm gost_${GOST_VERSION}_linux_amd64.tar.gz

# ===== 安装 Caddy =====
RUN wget https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_amd64.tar.gz && \
    tar -xzf caddy_${CADDY_VERSION}_linux_amd64.tar.gz && \
    mv caddy /usr/bin/caddy && \
    chmod +x /usr/bin/caddy && \
    rm caddy_${CADDY_VERSION}_linux_amd64.tar.gz

# ===== 环境变量 =====
ENV GOST_USER=name \
    GOST_PASS=pass \
    GOST_PORT=9000 \
    CADDY_PORT=3000

# ===== 静态文件 =====
RUN mkdir -p /var/www/html
COPY html /var/www/html

# ===== Caddy 配置 =====
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 8080

# ===== 启动 gost + caddy =====
CMD sh -c '\
  gost -L "socks5+ws://${GOST_USER}:${GOST_PASS}@127.0.0.1:${GOST_PORT}" & \
  exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile \
'
