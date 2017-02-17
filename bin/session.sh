#!/bin/sh

SCRIPTPATH=$(dirname $(readlink -f $0))
CONFFILE="$SCRIPTPATH/../conf/chrome-instances.conf"

# Clean up after GDM
xprop -root -remove _NET_NUMBER_OF_DESKTOPS -remove _NET_DESKTOP_NAMES -remove _NET_CURRENT_DESKTOP 2> /dev/null

if [ ! -f $CONFFILE ]; then
	echo "$CONFFILE not found!"
	exit 1
fi

# Start PulseAudio daemon
/usr/bin/pulseaudio --start

# Set audio volume
/usr/bin/amixer set Master 75% unmute

# Save current content of the DISPLAY variable
CURRENT_DISPLAY="$DISPLAY"

# Apply configuration
while read LINE; do
	if [ -z "$LINE" ]; then
		continue;
	fi

	if [ "`echo $LINE | colrm 2`" = "#" ]; then
		continue;
	fi

	SCREEN=$(echo "$LINE" | cut -d ' ' -f 1)
	CHROME_ARGUMENTS=$(echo "$LINE" | cut -d ' ' -f 2-)
	VNC_PORT=$((5900 + $SCREEN))
	CHROME_REMOTE_DEBUG_PORT=$((9200 + $SCREEN))

	export DISPLAY="$CURRENT_DISPLAY.$SCREEN"
	/usr/bin/x11vnc -rfbport $VNC_PORT -auth /var/run/lightdm/root/:$CURRENT_DISPLAY -shared -forever -localhost -bg -nopw -viewonly
	/usr/bin/openbox --startup "/usr/bin/google-chrome --remote-debugging-port=$CHROME_REMOTE_DEBUG_PORT --kiosk --no-first-run --incognito --new-window --user-data-dir=~/.config/chrome-instances/$SCREEN $CHROME_ARGUMENTS" &
done < $CONFFILE

# Wait till all window managers are closed
wait
