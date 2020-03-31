# rutorrent-flood-docker

A repository for creating a docker container including rtorrent with rutorrent and flood interfaces.

[![](https://images.microbadger.com/badges/version/romancin/rutorrent-flood.svg)](https://microbadger.com/images/romancin/rutorrent-flood "Docker image version")
[![](https://images.microbadger.com/badges/image/romancin/rutorrent-flood.svg)](https://microbadger.com/images/romancin/rutorrent-flood "Docker image size")
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X2CT2SWQCP74U)

You can invite me a beer if you want ;) 

## Description

This is a completely funcional Docker image with flood, rutorrent, rtorrent, libtorrent and a lot of plugins 
for rutorrent, like autodl-irssi, filemanager, fileshare and other useful ones.

Based on Alpine Linux, which provides a very small size. 

Includes plugins: logoff fileshare filemanager pausewebui mobile ratiocolor force_save_session showip ...

Also installed and selected by default this awesome theme: club-QuickBox

Also includes MaterialDesign theme as an option.

You need to run pyrocore commands with user "abc", which is who runs rtorrent, so use "su - abc" after connecting container before using pyrocore commands. If you already have torrents in your rtorrent docker instance, you have to add extra information before using pyrocore, check here: http://pyrocore.readthedocs.io/en/latest/setup.html in the "Adding Missing Data to Your rTorrent Session" topic.

rTelegram is added, that will allow you to control your rtorrent instance from Telegram client.

Tested and working on Synology and QNAP, but should work on any x86_64 devices.

## Instructions
- Map any local port to 80 for rutorrent access (Default username/password is admin/admin)
- Map any local port to 443 for SSL rutorrent access if SSL_ENABLED=yes (Default username/password is admin/admin)
- Map any local port to 51415 for rtorrent 
- Map any local port to 3000 for SSL flood access
- Map a local volume to /config (Stores configuration data, including rtorrent session directory. Consider this on SSD Disk) 
- Map a local volume to /downloads (Stores downloaded torrents)

In order to change rutorrent web access password execute this inside container: 
- `sh -c "echo -n 'admin:' > /config/nginx/.htpasswd"`
- `sh -c "libressl passwd -apr1 >> /config/nginx/.htpasswd"`

**IMPORTANT** 
- In newer versions of flood it is needed to specify how is the connection to rtorrent established in the first user creation window. Specify "Unix Socket" type and "/run/php/.rtorrent.sock" in the rTorrent Socket field.
- Since v1.0.0 version, rtorrent.rc file has changed completely, so rename it before starting with the new image the first time. After first run, add the changes you need to this config file. It is on <YOUR_MAPPED_FOLDER>/rtorrent directory.
- Since v2.0.0 version, config.php of rutorrent has added new utilities, so rename it before starting with the new image the first time. After first run, add the changes you need to this config file. It is on <YOUR_MAPPED_FOLDER>/rutorrent/settings directory.

## Sample run command

For rtorrent 0.9.8 version:
 
 ```bash
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:latest
```

For rtorrent 0.9.7 version:
 
 ```bash
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:0.9.7
```

For rtorrent 0.9.6 version:

```bash
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:0.9.6
```

For rtorrent 0.9.4 version:

```bash
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:0.9.4
```

Remember editing `/config/rtorrent/rtorrent.rc` with your own settings, especially your watch subfolder configuration.

## Environment variables supported

| Variable | Function |
| :----: | --- |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e CREATE_SUBDIR_BY_TRACKERS=YES` | YES to create downloads/watch subfolder for trackers (OLD BEHAVIOUR) or NO to create only completed/watch folder (DEFAULT) |
| `-e SSL_ENABLED=YES` | YES to enable SSL in nginx/flood or NO to not use it (DEFAULT) |
| `-e RT_TOKEN=your_bot_token` | for your Telegram BOT Token - [see rtelegram documentation for instructions](https://github.com/pyed/rtelegram/wiki/Getting-started). If not used, rtelegram won't start on boot. |
| `-e RT_MASTERS=your_real_telegram_username` | for your Telegram real username - [see rtelegram documentation for instructions](https://github.com/pyed/rtelegram/wiki/Getting-started). If not used, rtelegram won't start on boot. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Changelog
v4.0.2 (31/03/2020): Corrected rutorrentMobile plugin installation (Thanks @jorritsmit!!) and fixed instantsearch plugin

v4.0.0 (16/03/2020): Added variable for optional SSL configuration.

v3.0.0 (13/03/2020): Updated to Alpine 3.11 (rtorrent 0.9.8 only). Changed to new maxmind database.

v2.2.1 (20/09/2019): Unified Dockerfile and Jenkinsfile for easier image code management

v2.2.0 (09/09/2019): Added [rtelegram](https://github.com/pyed/rtelegram). It allows to control rtorrent from Telegram.

v2.1.0 (10/08/2019): Fixed cloudflare plugin. New 0.9.7 branch. Master branch updated to rtorrent/libtorrent 0.9.8/0.13.8.

v2.0.1 (29/04/2019): Added GeoIP2 plugin.

v2.0 (28/04/2019): Updated image to rutorrent 3.9. For the first time, I have eliminated the creation of subfolder directories for trackers by default. Since this moment, you can choose to create them using CREATE_SUBDIR_BY_TRACKERS variable. 

v1.0.1 (28/03/2019): curl 7.64.0 version has an issue that causes very high CPU usage in rtorrent. This version should fix this behaviour.

v1.0.0 (16/03/2019): NEW: rTorrent 0.9.7 / libtorrent 0.13.7 version. rtorrent.rc file has changed completely, rename it before starting with the new image the first time. After first run, add the changes you need to this config file.

vN/A: 05/08/2018: NEW: Includes Pyrocore/rtcontrol - http://pyrocore.readthedocs.io/en/latest/index.html
