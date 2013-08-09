#!/bin/sh

export LANG='ru_RU.UTF-8';
export LANGUAGE="${LANG}";
export LC_CTYPE="${LANG}";
export LC_NUMERIC="${LANG}";
export LC_TIME="${LANG}";
export LC_COLLATE="${LANG}";
export LC_MONETARY="${LANG}";
export LC_MESSAGES="${LANG}";
export LC_PAPER="${LANG}";
export LC_NAME="${LANG}";
export LC_ADDRESS="${LANG}";
export LC_TELEPHONE="${LANG}";
export LC_MEASUREMENT="${LANG}";
export LC_IDENTIFICATION="${LANG}";
export LC_ALL="${LANG}";

sleep 1;
#xlock -mode blank;
#xset s off;
xset +dpms;
xset dpms force on;
#beep -l 0.1 -r 3
xlock -mode blank -dpmsstandby 1 -dpmssuspend 1 -dpmsoff 1 +resetsaver;
xset s off;
xset -dpms;
