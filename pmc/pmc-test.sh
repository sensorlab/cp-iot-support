#!/usr/bin/env bash

/bin/stty -F /dev/ttyS2 115200 cs8 parodd -cstopb

while read line; do
	echo "$line"
done < /dev/ttyS2
