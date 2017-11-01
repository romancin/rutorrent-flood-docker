FROM lsiobase/alpine

MAINTAINER romancin

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BUILD_CORES
LABEL build_version="Romancin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ARG MEDIAINF_VER="0.7.92.1"
ARG RTORRENT_VER="0.9.4"
ARG LIBTORRENT_VER="0.13.4"
ARG CURL_VER="7.50.0"
ARG FLOOD_VER="1.0.0"

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV FLOOD_SECRET=password
ENV CONTEXT_PATH=/
    
# install runtime packages
#RUN apk del libressl-dev

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} && \
 apk add --no-cache \
        ca-certificates \
        fcgi \
        ffmpeg \
        geoip \
        gzip \
        logrotate \
        nginx \
	dtach \
        tar \
        unrar \
        unzip \
        wget \
	irssi \
	irssi-perl \
	zlib \
	zlib-dev \
	libxml2-dev \
	perl-archive-zip \
	perl-net-ssleay \
	perl-digest-sha1 \
	git \
	libressl \
	binutils \
	findutils \
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
	perl-dev \
        file \
        g++ \
        gcc \
        libtool \
        make \
        ncurses-dev \
	build-base \
	libtool \
	subversion \
	cppunit-dev \
	linux-headers \
	curl-dev \
        libressl-dev && \

# compile curl to fix ssl for rtorrent
cd /tmp && \
mkdir curl && \
cd curl && \
wget -qO- https://curl.haxx.se/download/curl-${CURL_VER}.tar.gz | tar xz --strip 1 && \
./configure --with-ssl && make -j ${NB_CORES} && make install && \
ldconfig /usr/bin && ldconfig /usr/lib && \

# install webui
 mkdir -p \
        /usr/share/webapps/rutorrent \
        /defaults/rutorrent-conf && \
 git clone https://github.com/Novik/ruTorrent.git \
        /usr/share/webapps/rutorrent/ && \
 mv /usr/share/webapps/rutorrent/conf/* \
        /defaults/rutorrent-conf/ && \
 rm -rf \
        /defaults/rutorrent-conf/users && \

# install webui extras
# QuickBox Theme
git clone https://github.com/QuickBox/club-QuickBox /usr/share/webapps/rutorrent/plugins/theme/themes/club-QuickBox && \
git clone https://github.com/Phlooo/ruTorrent-MaterialDesign /usr/share/webapps/rutorrent/plugins/theme/themes/MaterialDesign && \
# ruTorrent plugins
cd /usr/share/webapps/rutorrent/plugins/ && \
git clone https://github.com/orobardet/rutorrent-force_save_session force_save_session && \
git clone https://github.com/AceP1983/ruTorrent-plugins  && \
mv ruTorrent-plugins/* . && \
rm -rf ruTorrent-plugins && \
apk add --no-cache cksfv && \
git clone https://github.com/nelu/rutorrent-thirdparty-plugins.git && \
mv rutorrent-thirdparty-plugins/* . && \
rm -rf rutorrent-thirdparty-plugins && \
cd /usr/share/webapps/rutorrent/ && \
chmod 755 plugins/filemanager/scripts/* && \
cd /tmp && \
git clone https://github.com/mcrapet/plowshare.git && \
cd plowshare/ && \
make install && \
cd .. && \
rm -rf plowshare* && \
apk add --no-cache unzip bzip2 && \
cd /tmp && \
wget http://www.rarlab.com/rar/rarlinux-x64-5.4.0.tar.gz && \
tar zxvf rarlinux-x64-5.4.0.tar.gz && \
mv rar/rar /usr/bin && \
mv rar/unrar /usr/bin && \
rm -rf rar;rm rarlinux-* && \
cd /usr/share/webapps/rutorrent/plugins/ && \
git clone https://github.com/Gyran/rutorrent-pausewebui pausewebui && \
git clone https://github.com/Gyran/rutorrent-ratiocolor ratiocolor && \
sed -i 's/changeWhat = "cell-background";/changeWhat = "font";/g' /usr/share/webapps/rutorrent/plugins/ratiocolor/init.js && \
git clone https://github.com/Gyran/rutorrent-instantsearch instantsearch && \
git clone https://github.com/astupidmoose/rutorrent-logoff logoff && \
git clone https://github.com/xombiemp/rutorrentMobile && \
git clone https://github.com/dioltas/AddZip && \

# install autodl-irssi perl modules
 perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit' && \
 curl -L http://cpanmin.us | perl - App::cpanminus && \
	cpanm HTML::Entities XML::LibXML JSON JSON::XS && \

# compile xmlrpc-c
cd /tmp && \
#svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c && \
mkdir xmlrpc-c && \
cd /tmp/xmlrpc-c && \
wget -qO- https://sourceforge.net/projects/xmlrpc-c/files/latest/download?source=files | tar xz --strip 1 && \
./configure --with-libwww-ssl --disable-wininet-client --disable-curl-client --disable-libwww-client --disable-abyss-server --disable-cgi-server && make -j ${NB_CORES} && make install && \

# compile libtorrent
cd /tmp && \
mkdir libtorrent && \
cd libtorrent && \
wget -qO- https://github.com/rakshasa/libtorrent/archive/${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 && \
./autogen.sh && ./configure && make -j ${NB_CORES} && make install && \

# compile rtorrent
cd /tmp && \
mkdir rtorrent && \
cd rtorrent && \
wget -qO- https://github.com/rakshasa/rtorrent/archive/${RTORRENT_VER}.tar.gz | tar xz --strip 1 && \
./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install && \

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

# install flood webui
 apk add --no-cache nodejs \
 nodejs-npm && \
 mkdir /usr/flood && \
 cd /usr/flood && \
 git clone https://github.com/jfurrow/flood . && \
 npm install && \
 npm run build && \

# cleanup
 apk del --purge \
        build-dependencies && \
 rm -rf \
        /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 443 51415 3000
VOLUME /config /downloads
