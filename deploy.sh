#!/bin/bash

basedir=$(cd $(dirname $0) && pwd)

cd $basedir

mkdir -p /opt/cfssl/conf
\cp -rf cfssl/* /opt/cfssl/conf

mkdir -p /opt/squid
\cp -rf squid/* /opt/squid/

# 証明書を作成
docker run --rm -it \
  -v /opt/cfssl/conf:/opt/cfssl/conf \
  -v /opt/certs:/opt/certs \
  -e "CERT_DIR=/opt/certs" \
  -e "CA_CERT_PREFIX=/opt/certs/altus5.local.ca" \
  -e "SERVER_CONF=/opt/cfssl/conf/proxy.altus5.local.json" \
  -e "SERVER_CERT_PREFIX=/opt/certs/proxy.altus5.local" \
  altus5/cfssl:0.5.2 \
  gen_server_cert.sh

# 起動
#cd /opt/squid
#docker-compose up -d

