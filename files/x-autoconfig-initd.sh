#! /bin/sh

if [ ! -f /etc/X11/xorg.conf ]; then
	/usr/bin/x-autoconfig
fi
update-rc.d x-autoconfig remove
rm $0
