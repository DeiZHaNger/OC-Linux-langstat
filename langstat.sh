#!/bin/bash

alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
tmp='.dzlgsttmp'
if [ -e "$1" ]; then
	if [ -e $tmp ]; then
		rm $tmp
	fi
	for char in `echo "$alphabet" | sed -E s'/(.)/\1\n/g'`; do
		echo -e "$(grep $char $1 | wc -l)\t- $char" >> $tmp
	done
	sort -rn $tmp
	rm $tmp
else
	echo "syntax error: ' $0 filename '"
fi
