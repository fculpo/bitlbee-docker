FROM alpine:latest
LABEL maintainer=fculpo

ENV BITLBEE_VERSION 3.5.1

RUN set -x \
&& apk update \
&& apk upgrade \
&& apk add --virtual build-dependencies \
autoconf \
automake \
build-base \
curl \
git \
json-glib-dev \
libtool \
&& apk add --virtual runtime-dependencies \
glib-dev \
gnutls-dev \
libgcrypt-dev \
&& cd /root \
&& mkdir bitlbee-src \
&& cd bitlbee-src \
&& curl -fsSL "http://get.bitlbee.org/src/bitlbee-${BITLBEE_VERSION}.tar.gz" -o bitlbee.tar.gz \
&& tar -zxf bitlbee.tar.gz --strip-components=1 \
&& mkdir /bitlbee-data \
&& ./configure --config=/bitlbee-data \
&& make \
&& make install \
&& apk del --purge build-dependencies \
&& rm -rf /root/* \
&& rm -rf /var/cache/apk/* \
&& adduser -u 1000 -S bitlbee \
&& addgroup -g 1000 -S bitlbee \
&& chown -R bitlbee:bitlbee /bitlbee-data \
&& touch /var/run/bitlbee.pid \
&& chown bitlbee:bitlbee /var/run/bitlbee.pid; exit 0

USER bitlbee
VOLUME /bitlbee-data
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data"]
