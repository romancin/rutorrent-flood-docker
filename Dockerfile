FROM lsiobase/alpine

MAINTAINER xeroxmalf

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ARG MEDIAINF_VER="0.7.90"

# install runtime packages
RUN \
 apk add --no-cache \
        ca-certificates \
        curl \
        fcgi \
        ffmpeg \
        geoip \
        gzip \
        logrotate \
        nginx \
        rtorrent \
        screen \
        tar \
        unrar \
        unzip \
        wget \
	irssi \
        zip && \

 apk add --no-cache \
        --repository http://nl.alpinelinux.org/alpine/edge/community \
        php7 \
        php7-cgi \
        php7-fpm \
        php7-json  \
        php7-mbstring \
	php7-sockets \
        php7-pear && \

# install build packages
 apk add --no-cache --virtual=build-dependencies \
        autoconf \
        automake \
        cppunit-dev \
        curl-dev \
	perl-dev \
        file \
        g++ \
        gcc \
        libtool \
        make \
        ncurses-dev \
	git \
        openssl-dev && \

# install webui
 mkdir -p \
        /usr/share/webapps/rutorrent \
        /defaults/rutorrent-conf && \
 curl -o \
 /tmp/rutorrent.tar.gz -L \
        "https://github.com/Novik/ruTorrent/archive/master.tar.gz" && \
 tar xf \
 /tmp/rutorrent.tar.gz -C \
        /usr/share/webapps/rutorrent --strip-components=1 && \
 mv /usr/share/webapps/rutorrent/conf/* \
        /defaults/rutorrent-conf/ && \
 rm -rf \
        /defaults/rutorrent-conf/users && \

# install autodl-rutorrent
 git clone \
	"https://github.com/autodl-community/autodl-rutorrent.git" \
	/usr/share/webapps/rutorrent/plugins/autodl-rutorrent && \
 ln -s \
	/defaults/conf.php /usr/share/webapps/rutorrent/plugins/autodl-rutorrent/conf.php && \

# install autodl-irssi
 [[ ! -d /config/.autodl ]] && (mkdir /config/.autodl && chown -R abc:abc /config/.autodl) && \
 [[ ! -d /home/abc ]] && (mkdir /home/abc && chown -R abc:abc /home/abc) && \

 [[ ! -d /config/.irssi/scripts/.git ]] && (mkdir /config/.irssi && \
	git clone https://github.com/autodl-community/autodl-irssi.git /config/.irssi/scripts && \
	mkdir /config/.irssi/scripts/autorun && \
	ln -s /config/.irssi/scripts/autodl-irssi.pl /config/.irssi/scripts/autorun/autodl-irssi.pl && \
	chown -R abc:abc /config/.irssi ) && \

 wget --quiet -O /tmp/trackers.zip https://github.com/autodl-community/autodl-trackers/archive/master.zip && \
 cd /config/.irssi/scripts/AutodlIrssi/trackers && \
 unzip -q -o -j /tmp/trackers.zip && \
 rm /tmp/trackers.zip && \

 perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit' && \
 cpan Archive::Zip Net::SSLeay HTML::Entities XML::LibXML Digest::SHA JSON JSON::XS && \

 cd /usr/share/webapps/rutorrent/plugins/autodl-rutorrent && \
 git pull && \
 chown -R abc:abc /usr/share/webapps/rutorrent/plugins/autodl-rutorrent &&\

 cd /config/.irssi/scripts && \
 git pull && \
 chown -R abc:abc /config/.irssi && \

# compile mediainfo packages
 curl -o \
 /tmp/libmediainfo.tar.gz -L \
        "http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINF_VER}/MediaInfo_DLL_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 curl -o \
 /tmp/mediainfo.tar.gz -L \
        "http://mediaarea.net/download/binary/mediainfo/${MEDIAINF_VER}/MediaInfo_CLI_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 mkdir -p \
        /tmp/libmediainfo \
        /tmp/mediainfo && \
 tar xf /tmp/libmediainfo.tar.gz -C \
        /tmp/libmediainfo --strip-components=1 && \
 tar xf /tmp/mediainfo.tar.gz -C \
        /tmp/mediainfo --strip-components=1 && \

 cd /tmp/libmediainfo && \
        ./SO_Compile.sh && \
 cd /tmp/libmediainfo/ZenLib/Project/GNU/Library && \
        make install && \
 cd /tmp/libmediainfo/MediaInfoLib/Project/GNU/Library && \
        make install && \
 cd /tmp/mediainfo && \
        ./CLI_Compile.sh && \
 cd /tmp/mediainfo/MediaInfo/Project/GNU/CLI && \
        make install && \

# cleanup
 apk del --purge \
        build-dependencies && \
 rm -rf \
        /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 443
VOLUME /config /downloads
