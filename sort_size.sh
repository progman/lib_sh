#!/bin/bash
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# 0.0.1
# Alexey Potehin <gnuplanet@gmail.com>, http://www.gnuplanet.ru/doc/cv
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# example:
# $ echo '11'  > 2;
# $ echo '111' > 3;
# $ echo '1'   > 1;
# $ echo -e "2\n3\n1" | sort_size.sh
# 1
# 2
# 3
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
function do_it
{
# create file for filelist
	TMP1=$(mktemp);
	if [ "${?}" != "0" ];
	then
		echo "FATAL: can't make tmp file";
		return 1;
	fi

# create file for sorted filelist
	TMP2=$(mktemp);
	if [ "${?}" != "0" ];
	then
		echo "FATAL: can't make tmp file";
		rm -rf "${TMP1}" &> /dev/null;
		return 1;
	fi

# add in filelist exist files
	while read -r LINE;
	do
		if [ -f "${LINE}" ];
		then
			SIZE=$(stat --printf='%s' "${LINE}");
			echo "${SIZE} ${LINE}" >> "${TMP1}";
		fi
	done


# sort filelist
	sort -n "${TMP1}" | sed -e 's/^[0-9]*\ //g' > "${TMP2}";
	rm -rf "${TMP1}" &> /dev/null;

	while read -r LINE;
	do
		echo "${LINE}";
	done < "${TMP2}";
	rm -rf "${TMP2}" &> /dev/null;


	return 0;
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
do_it;

exit "${?}";
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
