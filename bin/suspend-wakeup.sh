#! /bin/bash

set -e

SCRIPTPATH=$(dirname $(readlink -f $0))
NOW=$(date +%s)
NEXTTIMESTAMP=0

CONFFILE="$SCRIPTPATH/../conf/suspend-wakeup.conf"

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

		if [ "$ACTION" == "wakeup" ]; then
			WEEKDAYS[1]="monday"
			WEEKDAYS[2]="tuesday"
			WEEKDAYS[3]="wednesday"
			WEEKDAYS[4]="thursday"
			WEEKDAYS[5]="friday"
			WEEKDAYS[6]="saturday"
			WEEKDAYS[7]="sunday"

			if [ "`date +%u`" == "$DAY" ]; then
				TIMESTAMP=$(date -d "$TIME_HOUR:$TIME_MINUTE" +%s)
				if ((TIMESTAMP > NOW)) && ((NEXTTIMESTAMP == 0 || TIMESTAMP < NEXTTIMESTAMP)); then
					NEXTTIMESTAMP=$TIMESTAMP
				fi
			fi

			TIMESTAMP=$(date -d "next ${WEEKDAYS[$DAY]} $TIME_HOUR:$TIME_MINUTE" +%s)
			if ((TIMESTAMP > NOW)) && ((NEXTTIMESTAMP == 0 || TIMESTAMP < NEXTTIMESTAMP)); then
				NEXTTIMESTAMP=$TIMESTAMP
			fi
		fi
	done < $CONFFILE

	if ((NEXTTIMESTAMP > 0)); then
		/usr/sbin/rtcwake -v -m mem -t $NEXTTIMESTAMP > /dev/null
	fi
else
	echo "$CONFFILE not found!"
fi
