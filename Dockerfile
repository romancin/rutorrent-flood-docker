ARG BASE_IMAGE
FROM $BASE_IMAGE

MAINTAINER romancin

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BUILD_CORES
LABEL build_version="Romancin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CONTEXT_PATH=/
ENV CREATE_SUBDIR_BY_TRACKERS="no"
ENV SSL_ENABLED="no"

# run commands

# install flood webui
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} && \
    apk add --no-cache \
      nodejs \
      npm && \
    apk add --no-cache --virtual=build-dependencies \
      build-base && \
    mkdir /usr/flood && \
    cd /usr/flood && \
    git clone https://github.com/jesec/flood.git .&& \
    npm install --prefix /usr/flood && \
    npm run build && \
    npm prune --production && \
    apk del --purge build-dependencies && \
    rm -rf /root \
           /tmp/* && \
    ln -s /usr/local/bin/mediainfo /usr/bin/mediainfo

# add local files
COPY root/ /
COPY VERSION /

# ports and volumes
EXPOSE 443 51415 3000
VOLUME /config /downloads
