#!/bin/sh

export LANG='ru_RU.CP1251';
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

linuxdcpp &> /dev/null < /dev/null &
