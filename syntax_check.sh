#!/bin/bash

if [ "${1}" == "" ] || [ ! -e "${1}" ];
then
	echo "${0} FILE";
	exit 1;
fi

grep -H -n 'if(' "${1}";
grep -H -n 'for(' "${1}";
grep -H -n 'while(' "${1}";
grep -H -n 'do{' "${1}";

exit 0;
