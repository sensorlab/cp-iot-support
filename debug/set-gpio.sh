#!/usr/bin/env bash

GPIO="$1"
VALUE="$2"

if [ -z "$GPIO" ]; then
	echo "Error: No GPIO supplied!"
	exit 1
fi

if [ -z "$VALUE" ]; then
	echo "Error: No VALUE supplied!"
	exit 1  
fi

DIR="/sys/class/gpio/gpio$GPIO"

echo "Working with $DIR"

if ! [ -d $DIR ]; then
	echo "$GPIO" > /sys/class/gpio/export
	echo "out" > /sys/class/gpio/gpio"$GPIO"/direction
	echo "exporting ..."
fi

echo "$VALUE" > /sys/class/gpio/gpio"$GPIO"/value
echo "setting to ""$VALUE"
