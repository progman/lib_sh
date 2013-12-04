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
# show line
function show()
{
	local MAX_LINE_WIDTH="${1}";
	local BRANCH1="${2}";
	local TOKEN="${3}";
	local BRANCH2="${4}";


	echo -n "${BRANCH1}";


	local LINE_WIDTH=${#BRANCH1};
	while true;
	do
		if [ ${LINE_WIDTH} -ge ${MAX_LINE_WIDTH} ]; # LINE_WIDTH >= MAX_LINE_WIDTH
		then
			break;
		fi

		echo -n " ";

		(( LINE_WIDTH++ ));
	done;


	echo "    ${TOKEN}    ${BRANCH2}";
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# general function
function main()
{
	if [ ! -d "${1}" ] || [ ! -d "${2}" ];
	then
		echo "example: ${0} GITDIR1 GITDIR2";
		return 1;
	fi


# check minimal depends tools
	check_prog "echo git head grep wc sed sha1sum cat";
	if [ "${?}" != "0" ];
	then
		return 1;
	fi


# save current dir
	DIR_CUR="${PWD}";


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
		echo "can't make tmp file";
		rm -rf -- "${TMP1}";
		return 1;
	fi


# create branch list for dir1
	cd -- "${1}";
	if [ "$(git log 2> /dev/null | head -n 1 | grep commit | wc -l)" == "0" ];
	then
		echo "ERROR: \"${1}\" is not GIT dir";
		cd -- "${DIR_CUR}";
		rm -rf -- "${TMP1}";
		rm -rf -- "${TMP2}";
		return 1;
	fi


	git branch | sed -e 's/^*\ //g' |
	{
		while read -r BRANCH;
		do

			echo -n "${BRANCH} ";
			git log "${BRANCH}" 2> /dev/null | head -n 1 | grep commit | { read a b; echo ${b}; };

		done > "${TMP1}";
	}


# create branch list for dir2
	cd -- "${2}";
	if [ "$(git log 2> /dev/null | head -n 1 | grep commit | wc -l)" == "0" ];
	then
		echo "ERROR: \"${2}\" is not GIT dir";
		cd -- "${DIR_CUR}";
		rm -rf -- "${TMP1}";
		rm -rf -- "${TMP2}";
		return 1;
	fi


	git branch | sed -e 's/^*\ //g' |
	{
		while read -r BRANCH;
		do

			echo -n "${BRANCH} ";
			git log "${BRANCH}" 2> /dev/null | head -n 1 | grep commit | { read a b; echo ${b}; };

		done > "${TMP2}";
	}


# check stupid equals
	LIST1_SHA=$(sha1sum "${TMP1}" | { read a b; echo "${a}"; });
	LIST2_SHA=$(sha1sum "${TMP2}" | { read a b; echo "${a}"; });


	if [ "${LIST1_SHA}" == "${LIST2_SHA}" ];
	then
		echo "GITDIR1 == GITDIR2";
		rm -rf -- "${TMP1}";
		rm -rf -- "${TMP2}";
		return 0;
	fi


	echo "GITDIR1 != GITDIR2";
	echo;


# compute max line width
	local MAX_LINE_WIDTH=0;

	while read -r BRANCH HASH;
	do
		if [ ${#BRANCH} -gt ${MAX_LINE_WIDTH} ]; # strlen(BRANCH) > MAX_LINE_WIDTH
		then
			MAX_LINE_WIDTH=${#BRANCH};
		fi
	done < "${TMP1}";
	while read -r BRANCH HASH;
	do
		if [ ${#BRANCH} -gt ${MAX_LINE_WIDTH} ]; # strlen(BRANCH) > MAX_LINE_WIDTH
		then
			MAX_LINE_WIDTH=${#BRANCH};
		fi
	done < "${TMP2}";


# compare GITDIR1 and GITDIR2
	while read -r BRANCH1 HASH1;
	do
		local FLAG_FOUND=0;
		while read -r BRANCH2 HASH2;
		do
			if [ "${BRANCH1}" == "${BRANCH2}" ];
			then
				FLAG_FOUND=1;
				break;
			fi
		done < "${TMP2}";

		if [ "${FLAG_FOUND}" == "0" ];
		then
			show "${MAX_LINE_WIDTH}" "${BRANCH1}" "!=" "null";
		else
			if [ "${HASH1}" != "${HASH2}" ];
			then
				show "${MAX_LINE_WIDTH}" "${BRANCH1}" "!=" "${BRANCH2}";
			else
				show "${MAX_LINE_WIDTH}" "${BRANCH1}" "==" "${BRANCH2}";
			fi
		fi
	done < "${TMP1}";


# compare GITDIR2 and GITDIR1
	while read -r BRANCH2 HASH2;
	do
		local FLAG_FOUND=0;
		while read -r BRANCH1 HASH1;
		do
			if [ "${BRANCH1}" == "${BRANCH2}" ];
			then
				FLAG_FOUND=1;
				break;
			fi
		done < "${TMP1}";

		if [ "${FLAG_FOUND}" == "0" ];
		then
			show "${MAX_LINE_WIDTH}" "null" "!=" "${BRANCH2}";
		fi
	done < "${TMP2}";



	rm -rf -- "${TMP1}";
	rm -rf -- "${TMP2}";


	return 0;
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
main "${@}";

exit "${?}";
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
