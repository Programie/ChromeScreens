#! /bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root!"
	exit 1
fi

SCRIPTPATH=$(dirname $(readlink -f $0))

echo "This script will configure this computer to display one Google Chrome instance on each of the available screens."
echo ""
echo "Press [ENTER] to start the configuration or [CTRL+C] to exit."
read

echo "Adding contrib package source list..."
echo "deb http://http.debian.net/debian/ wheezy contrib" > /etc/apt/sources.list.d/debian-contrib.list

echo "Adding non-free package source list..."
echo "deb http://http.debian.net/debian/ wheezy non-free" > /etc/apt/sources.list.d/debian-non-free.list

echo "Updating package lists..."
aptitude update

echo "Installing/updating required packages..."
aptitude install -y alsa-utils gdebi-core htop lightdm linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-kernel-dkms nvidia-xconfig openbox pulseaudio unclutter vim xserver-xorg x11vnc

echo "Downloading and installing Google Chrome..."
ARCH="`arch`"
case "$ARCH" in
	amd64)
		CHROME_ARCH="amd64"
	;;
	i386)
		CHROME_ARCH="i386"
	;;
	x86_64)
		CHROME_ARCH="amd64"
	;;
	*)
		echo "Unknown architecture: $ARCH!"
		exit 1
	;;
esac

wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_$CHROME_ARCH.deb
gdebi --n /tmp/google-chrome.deb
rm -f /tmp/google-chrome.deb

if [ -z "`getent passwd chromescreens`" ]; then
	echo "Creating user 'chromescreens'..."
	useradd -m chromescreens
fi

echo "Writing XSession file..."
cat > /usr/share/xsessions/chromescreens.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=ChromeScreens
Exec=$SCRIPTPATH/bin/session.sh
TryExec=$SCRIPTPATH/bin/session.sh
Type=XSession
EOF

echo "Generating symbolic links..."
ln -fs $SCRIPTPATH/bin/x-autoconfig-initd.sh /etc/init.d/x-autoconfig
ln -fs $SCRIPTPATH/conf/lightdm.conf /etc/lightdm.conf
ln -fs $SCRIPTPATH/conf/disable-beep.conf /etc/modprobe.d/disable-beep.conf

echo "Registering x-autoconfig init.d script..."
update-rc.d x-autoconfig defaults

if [ ! -f $SCRIPTPATH/conf/suspend-wakeup.conf ]; then
	echo "Copying example suspend-wakeup configuration..."
	cp $SCRIPTPATH/conf/suspend-wakeup.conf.sample $SCRIPTPATH/conf/suspend-wakeup.conf
fi

if [ ! -f $SCRIPTPATH/conf/chrome-instances.conf ]; then
	echo "Copying example chrome-instances configuration..."
	cp $SCRIPTPATH/conf/chrome-instances.conf.sample $SCRIPTPATH/conf/chrome-instances.conf
fi

echo "Done"
echo ""
echo "If not already done, please edit $SCRIPTPATH/conf/chrome-instances.conf (required) and $SCRIPTPATH/conf/suspend-wakeup.conf (optional)."
echo ""
echo "*** IMPORTANT ***"
echo "If you already have rebooted this machine after the first execution of this script"
echo "you may now restart the display manager using 'service lightdm restart'."
echo "Otherwise please reboot now!"
