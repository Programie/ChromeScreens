#! /bin/sh

echo "Configuring X server..."
rm -f /etc/X11/xorg.conf
/usr/bin/nvidia-xconfig --enable-all-gpus --separate-x-screens
