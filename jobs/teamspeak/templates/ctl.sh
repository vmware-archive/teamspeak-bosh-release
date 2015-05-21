#!/bin/sh
# Copyright (c) 2010 TeamSpeak Systems GmbH
# All rights reserved

#COMMANDLINE_PARAMETERS="${2}" #add any command line parameters you want to pass here
#D1=$(readlink -f "$0")
#BINARYPATH="$(dirname "${D1}")"
#cd "${BINARYPATH}"
#LIBRARYPATH="$(pwd)"

BINARYPATH=/var/vcap/packages/teamspeak-3.0.11.3
LIBRARYPATH=$BINARYPATH
BINARYNAME=ts3server_linux_amd64
TEAMSPEAK_PID=/var/vcap/sys/run/teamspeak/teamspeak.pid

cd $BINARYPATH

case "$1" in
	start)
		if [ -e $TEAMSPEAK_PID ]; then
			if ( kill -0 $(cat $TEAMSPEAK_PID) 2> /dev/null ); then
				echo "The server is already running, try restart or stop"
				exit 1
			else
				echo "$TEAMSPEAK_PID found, but no server running. Possibly your previously started server crashed"
				echo "Please view the logfile for details."
				rm $TEAMSPEAK_PID
			fi
		fi
		echo "Starting the TeamSpeak 3 server"
		if [ -e "$BINARYNAME" ]; then
			if [ ! -x "$BINARYNAME" ]; then
				echo "${BINARYNAME} is not executable, trying to set it"
				chmod u+x "${BINARYNAME}"
			fi
			if [ -x "$BINARYNAME" ]; then
				export LD_LIBRARY_PATH="${LIBRARYPATH}:${LD_LIBRARY_PATH}"
				"./${BINARYNAME}" ${COMMANDLINE_PARAMETERS} > /dev/null &
 				PID=$!
				ps -p ${PID} > /dev/null 2>&1
				if [ "$?" -ne "0" ]; then
					echo "TeamSpeak 3 server could not start"
				else
					echo $PID > $TEAMSPEAK_PID
					echo "TeamSpeak 3 server started, for details please view the log file"
				fi
			else
				echo "${BINARNAME} is not exectuable, cannot start TeamSpeak 3 server"
			fi
		else
			echo "Could not find binary, aborting"
			exit 5
		fi
	;;
	stop)
		if [ -e $TEAMSPEAK_PID ]; then
			echo -n "Stopping the TeamSpeak 3 server"
			if ( kill -TERM $(cat $TEAMSPEAK_PID) 2> /dev/null ); then
				c=1
				while [ "$c" -le 300 ]; do
					if ( kill -0 $(cat $TEAMSPEAK_PID) 2> /dev/null ); then
						echo -n "."
						sleep 1
					else
						break
					fi
					c=$(($c+1))
				done
			fi
			if ( kill -0 $(cat $TEAMSPEAK_PID) 2> /dev/null ); then
				echo "Server is not shutting down cleanly - killing"
				kill -KILL $(cat $TEAMSPEAK_PID)
			else
				echo "done"
			fi
			rm $TEAMSPEAK_PID
		else
			echo "No server running ($TEAMSPEAK_PID is missing)"
			exit 7
		fi
	;;
	restart)
		$0 stop && $0 start ${COMMANDLINE_PARAMETERS} || exit 1
	;;
	status)
		if [ -e $TEAMSPEAK_PID ]; then
			if ( kill -0 $(cat $TEAMSPEAK_PID) 2> /dev/null ); then
				echo "Server is running"
			else
				echo "Server seems to have died"
			fi
		else
			echo "No server running ($TEAMSPEAK_PID is missing)"
		fi
	;;
	*)
		echo "Usage: ${0} {start|stop|restart|status}"
		exit 2
esac
exit 0
