#! /bin/bash

set -e

echo "This script will configure this computer to display one Google Chrome instance on each of the available screens."
echo "Press [ENTER] to start the configuration or [CTRL+C] to exit."
read

echo "Adding contrib package source list..."
cp files/sources.list.d/debian-contrib.list /etc/apt/sources.list.d/debian-contrib.list

echo "Adding non-free package source list..."
cp files/sources.list.d/debian-non-free.list /etc/apt/sources.list.d/debian-non-free.list

echo "Updating package lists..."
aptitude update

echo "Installing/updating required packages..."
aptitude install -y alsa-utils gdebi-core htop lightdm linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-kernel-dkms nvidia-xconfig openbox pulseaudio unclutter vim xserver-xorg

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
rm /tmp/google-chrome.deb

echo "Disabling beep..."
cp files/disable-beep.conf /etc/modprobe.d/disable-beep.conf

if [ -z "`getent passwd chromescreens`" ]; then
	echo "Creating user 'chromescreens'..."
	useradd chromescreens
fi

echo "Copying X server auto configuration script..."
cp files/x-autoconfig.sh /usr/bin/x-autoconfig
chmod +x /usr/bin/x-autoconfig

echo "Copying X server auto configuration init script..."
cp files/x-autoconfig-initd.sh /etc/init.d/x-autoconfig
chmod +x /etc/init.d/x-autoconfig
update-rc.d x-autoconfig defaults

echo "Copying LightDM configuration..."
cp files/lightdm.conf /etc/lightdm/lightdm.conf

echo "Copying session script..."
cp files/sessions.sh /usr/bin/chromescreens-session
chmod +x /usr/bin/chromescreens-session

echo "Copying session file..."
cp files/session.desktop /usr/share/xsessions/chromescreens.desktop

if [ ! -f /etc/chrome-instances.conf ]; then
	echo "Copying example configuration..."
	cp files/chrome-instances.conf.sample /etc/chrome-instances.conf
fi

/usr/bin/editor /etc/chrome-instances.conf

echo "Done"
echo ""
echo "*** IMPORTANT ***"
echo "If you already have rebooted this machine after the first execution of this script"
echo "you may now restart the display manager using 'service lightdm restart'."
echo "Otherwise please reboot now!"
