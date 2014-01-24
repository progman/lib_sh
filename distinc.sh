#!/bin/bash
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# 0.0.1
# Alexey Potehin <gnuplanet@gmail.com>, http://www.gnuplanet.ru/doc/cv
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# check depends
function check_prog()
{
	for i in ${1};
	do
		if [ "$(which ${i})" == "" ];
		then
			echo "FATAL: you must install \"${i}\"...";
			return 1;
		fi
	done

	return 0;
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# view help
function help()
{
	echo "example: ${0} DIR";
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# general function
function main()
{
# check minimal depends tools
	check_prog "cp echo date";
	if [ "${?}" != "0" ];
	then
		return 1;
	fi


# check arguments
	if [ "${#}" != 1 ];
	then
		help "${@}";
		return 1;
	fi

	if [ ! -d "${1}" ];
	then
		help "${@}";
		return 1;
	fi


# create tmp file
	local TMP1;
	TMP1="$(mktemp)";
	if [ "${?}" != "0" ];
	then
		echo "can't make tmp file";
		return 1;
	fi


# create tmp file
	local TMP2;
	TMP2="$(mktemp)";
	if [ "${?}" != "0" ];
	then
		rm -rf -- "${TMP1}";
		echo "can't make tmp file";
		return 1;
	fi


# create tmp file
	local TMP3;
	TMP3="$(mktemp)";
	if [ "${?}" != "0" ];
	then
		rm -rf -- "${TMP1}";
		rm -rf -- "${TMP2}";
		echo "can't make tmp file";
		return 1;
	fi


# save current dir
	local DIR_CUR="${PWD}";


	local DIR="${1}";
	cd -- "${DIR}";
	DIR="${PWD}";
	cd -- "${DIR_CUR}";


	find "${DIR}" -maxdepth 1 -type f > "${TMP1}";


	while read -r FILE;
	do
		md5sum "${FILE}" >> "${TMP2}";
	done < "${TMP1}";


	sort "${TMP2}" > "${TMP3}";


	OLD_HASH="";
	while read -r HASH FILE;
	do
		if [ "${HASH}" == "${OLD_HASH}" ];
		then
			rm -rf "${FILE}";
		fi
		OLD_HASH="${HASH}";
	done < "${TMP3}";


	rm -rf -- "${TMP1}";
	rm -rf -- "${TMP2}";
	rm -rf -- "${TMP3}";


	return 0;
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
main "${@}";

exit "${?}";
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
