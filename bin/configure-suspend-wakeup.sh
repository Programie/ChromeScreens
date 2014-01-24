#! /bin/bash

set -e

SCRIPTPATH=$(dirname $(readlink -f $0))

CRONFILE="/etc/cron.d/chromescreens-suspend-wakeup"
CONFFILE="$SCRIPTPATH/../conf/suspend-wakeup.conf"

echo "Removing old entries..."
rm -f $CRONFILE

LINENUMBER=0
if [ -f $CONFFILE ]; then
	while read LINE; do
		LINENUMBER=$[$LINENUMBER + 1]

		if [ -z "$LINE" ]; then
			continue
		fi

		if [ "`echo $LINE | colrm 2`" = "#" ]; then
			continue
		fi

		DAY=$(echo "$LINE" | cut -d ' ' -f 1)
		ACTION=$(echo "$LINE" | cut -d ' ' -f 2)
		TIME=$(echo "$LINE" | cut -d ' ' -f 3)

		if [ -z "$DAY" ]; then
			echo "Line $LINENUMBER: No day defined!"
			continue
		fi

		if [ -z "$ACTION" ]; then
			echo "Line $LINENUMBER: No action defined!"
			continue
		fi

		if [ -z "$TIME" ]; then
			echo "Line $LINENUMBER: No time defined!"
			continue
		fi

		if ((DAY < 1 || DAY > 7)); then
			echo "Line $LINENUMBER: Day must be a number between 1 and 7!"
			continue
		fi

		TIME_HOUR=$(echo "$TIME" | cut -d ':' -f 1)
		TIME_MINUTE=$(echo "$TIME" | cut -d ':' -f 2)

		if ((TIME_HOUR < 0 || TIME_HOUR > 23)); then
			echo "Line $LINENUMBER: The hour part of the time must be a number between 0 and 23!"
			continue
		fi

		if ((TIME_MINUTE < 0 || TIME_MINUTE > 59)); then
			echo "Line $LINENUMBER: The minute part of the time must be a number between 0 and 59!"
			continue
		fi

		if [ "$ACTION" == "suspend" ]; then
			echo "$TIME_MINUTE $TIME_HOUR * * $DAY root $SCRIPTPATH/suspend-wakeup.sh" >> $CRONFILE
		fi
	done < $CONFFILE
else
	echo "$CONFFILE not found!"
fi
