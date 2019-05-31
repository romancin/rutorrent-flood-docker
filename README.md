# rutorrent-flood-docker

A repository for creating a docker container including rtorrent with rutorrent and flood interfaces.


[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/THOSNI330?locale.x=en_US)

You can invite me a beer if you want ;) 

## Description

This is a completely funcional Docker image with flood, rutorrent, rtorrent, libtorrent and a lot of plugins 
for rutorrent, like autodl-irssi, filemanager, fileshare and other useful ones.

Based on Alpine Linux, which provides a very small size. 

Includes plugins: logoff fileshare filemanager pausewebui mobile ratiocolor force_save_session showip ...

Also installed and selected by default this awesome theme: club-QuickBox

Also includes MaterialDesign theme as an option.

You need to run pyrocore commands with user "abc", which is who runs rtorrent, so use "su - abc" after connecting container before using pyrocore commands. If you already have torrents in your rtorrent docker instance, you have to add extra information before using pyrocore, check here: http://pyrocore.readthedocs.io/en/latest/setup.html in the "Adding Missing Data to Your rTorrent Session" topic.

Tested and working on Synology and QNAP, but should work on any x86_64 devices.

## Instructions

- Map any local port to 8080 rutorrent access
- Map a local volume to /config (Stores configuration data, including rtorrent session directory. Consider this on SSD Disk) 
- Map a local volume to /downloads (Stores downloaded torrents)

In order to change rutorrent web access password execute this inside container: 
- `sh -c "echo -n 'admin:' > /config/nginx/.htpasswd"`
- `sh -c "openssl passwd -apr1 >> /config/nginx/.htpasswd"`

**IMPORTANT** 
- In newer versions of flood it is needed to specify how is the connection to rtorrent established in the first user creation window. Specify "Unix Socket" type and "/run/php/.rtorrent.sock" in the rTorrent Socket field.
- Since v1.0.0 version, rtorrent.rc file has changed completely, so rename it before starting with the new image the first time. After first run, add the changes you need to this config file. It is on <YOUR_MAPPED_FOLDER>/rtorrent directory.
- Since v2.0.0 version, config.php of rutorrent has added new utilities, so rename it before starting with the new image the first time. After first run, add the changes you need to this config file. It is on <YOUR_MAPPED_FOLDER>/rutorrent/settings directory.

## Sample run command


```
version: 3
services:
  rutorrent-flood:
    image: tarek369/rutorrent:beta
    container_name: rutorrent-beta
    volumes:
      - '/share/Container/rutorrent-flood/config:/config'
      - '/share/Container/rutorrent-flood/downloads:/downloads'
    environment:
      - PGID=0
      - PUID=0
      - TZ=Europe/Madrid
    ports:
      - '51415-51415:51415-51415'
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:rtorrent.xxxx.com
      - traefik.port=8080
      - traefik.docker.network=traefik_proxy
    networks:
      - proxy
      - torrent
```
