#!/bin/bash
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
if [ ! -d "${1}" ] || [ ! -d "${2}" ];
then
	echo "example: ${0} SOURCE_DIR TARGET_DIR";
	exit 1;
fi

# check race condition

if [ "${RSYNC_PIDFILE}" == "" ];
then
	RSYNC_PIDFILE="/var/run/rsync.pid";
fi

if [ -e "${RSYNC_PIDFILE}" ];
then
	PID="$(cat ${RSYNC_PIDFILE})";

	kill -0 "${PID}" &> /dev/null;
	if [ "${?}" == "0" ];
	then
		exit 1; # program already run
	fi
fi
echo "${BASHPID}" > "${RSYNC_PIDFILE}";

#rsync -azLv --safe-links
rsync -av --delete "${1}" "${2}";

exit 0;
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
