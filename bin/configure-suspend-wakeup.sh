#! /bin/bash

SCRIPTPATH=$(dirname $(readlink -f $0))

CRON_FILE="/etc/cron.d/chromescreens-suspend-wakeup"

if [ -f suspend-wakeup.conf ]; then
	echo "Found suspend-wakeup.conf"
	echo "Configuring automatic suspend and wakeup..."

	rm $CRON_FILE

	while read LINE; do
		if [ -z "$LINE" ]; then
			continue
		fi

		if [ "`echo $LINE | colrm 2`" = "#" ]; then
			continue
		fi

		DAY=$(echo "$LINE" | cut -f 1)
		WAKEUP_TIME=$(echo "$LINE" | cut -f 2)
		SUSPEND_TIME=$(echo "$LINE" | cut -f 3)

		if [ -z "$WAKEUP_TIME" ]; then
			echo "No wakeup time defined for day $DAY"
			continue
		fi

		if [ -z "$SUSPEND_TIME" ]; then
			echo "No suspend time defined for day $DAY"
			continue
		fi

		WAKEUP_TIME_HOUR=$(echo "$WAKEUP_TIME" | cut -d ':' -f 1)
		WAKEUP_TIME_MINUTE=$(echo "$WAKEUP_TIME" | cut -d ':' -f 2)

		SUSPEND_TIME_HOUR=$(echo "$SUSPEND_TIME" | cut -d ':' -f 1)
		SUSPEND_TIME_MINUTE=$(echo "$SUSPEND_TIME" | cut -d ':' -f 2)

		if [ -z "$WAKEUP_TIME_HOUR" ]; then
			echo "No wakeup hour defined for day $DAY"
			continue
		fi

		if [ -z "$SUSPEND_TIME_HOUR" ]; then
			echo "No suspend hour defined for day $DAY"
			continue
		fi

		if [ -z "$WAKEUP_TIME_MINUTE" ]; then
			WAKEUP_TIME_MINUTE="0"
		fi

		if [ -z "$SUSPEND_TIME_MINUTE" ]; then
			SUSPEND_TIME_MINUTE="0"
		fi

		echo "$SUSPEND_TIME_MINUTE $SUSPEND_TIME_HOUR * * $DAY root $SCRIPTPATH/suspend-wakeup.sh" >> $CRON_FILE
	done < $SCRIPTPATH/../conf/suspend-wakeup.conf
fi
