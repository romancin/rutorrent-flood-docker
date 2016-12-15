#!/usr/bin/with-contenv bash
#screen -D -m -S \
#        irssi s6-setuidgid abc /usr/bin/irssi \
#        --home=/config/.irssi
#
#sleep 1s
if [ -f "/detach_sess/.irssi" ]; then
rm -f /detach_sess/.irssi || true
sleep 1s
fi

HOME=/config;dtach -n /detach_sess/.irssi s6-setuidgid abc /usr/bin/irssi --home=/config/.irssi 1>/dev/null

sleep 1s
