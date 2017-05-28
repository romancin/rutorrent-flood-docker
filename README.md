# rutorrent-flood-docker
A repository for creating a docker container including rtorrent with rutorrent and flood interfaces

[![](https://images.microbadger.com/badges/version/romancin/rutorrent-flood.svg)](https://microbadger.com/images/romancin/rutorrent-flood "Docker image version")
[![](https://images.microbadger.com/badges/image/romancin/rutorrent-flood.svg)](https://microbadger.com/images/romancin/rutorrent-flood "Docker image size")
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X2CT2SWQCP74U)

You can invite me a beer if you want ;) 

This is a completely funcional Docker image with flood, rutorrent, rtorrent, libtorrent and a lot of plugins 
for rutorrent, like autodl-irssi, filemanager, fileshare and other useful ones.

Based on Alpine Linux, which provides a very small size. 

Includes plugins: logoff fileshare filemanager pausewebui mobile ratiocolor force_save_session showip ...

Also installed and selected by default this awesome theme: club-QuickBox

Also includes MaterialDesign theme as an option.

Tested and working on Synology and QNAP, but should work on any x86_64 devices.

Instructions: 
- Map any local port to 443 for SSL rutorrent access (Default username/password is admin/admin) 
- Map any local port to 51415 for rtorrent 
- Map any local port to 3000 for SSL flood access
- Map a local volume to /config (Stores configuration data, including rtorrent session directory. Consider this on SSD Disk) 
- Map a local volume to /downloads (Stores downloaded torrents)

In order to change rutorrent web access password execute this inside container: 
- sh -c "echo -n 'admin:' > /config/nginx/.htpasswd"
- sh -c "openssl passwd -apr1 >> /config/nginx/.htpasswd"

Sample run command:

For rtorrent 0.9.6 version: \
\
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:latest \

For rtorrent 0.9.4 version: \
\
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:0.9.4 \

Rememeber editing /config/rtorrent/rtorrent.rc with your own settings, specially your watch subfolder configuration.
