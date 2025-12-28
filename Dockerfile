FROM alpine:latest

ARG GOST_VERSION=2.12.0

RUN apk add --no-cache wget tar && \
    wget https://github.com/ginuerzh/gost/releases/download/v${GOST_VERSION}/gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    tar -xzf gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    mv gost /usr/bin/gost && \
    chmod +x /usr/bin/gost && \
    rm gost_${GOST_VERSION}_linux_amd64.tar.gz && \
    apk del wget tar

# ===== 环境变量（可在运行时覆盖）=====
ENV GOST_USER=name \
    GOST_PASS=pass \
    GOST_PORT=3000

EXPOSE 3000

# 使用 shell 形式，支持环境变量展开
CMD sh -c 'gost -L "socks5+ws://${GOST_USER}:${GOST_PASS}@:${GOST_PORT}"'
