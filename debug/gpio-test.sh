#!/usr/bin/env bash

GPIO="$1"

if [ -z "$GPIO" ]; then
	echo "Error: No GPIO supplied!"
	exit 1
fi

DIR="/sys/class/gpio/gpio$GPIO"

echo "Working with $DIR"

if ! [ -d $DIR ]; then
	echo "$GPIO" > /sys/class/gpio/export
	echo "out" > /sys/class/gpio/gpio"$GPIO"/direction
	echo "exporting ..."
fi

while true; do
	echo "1" > /sys/class/gpio/gpio"$GPIO"/value
	echo "toggling ... 1"
	sleep 1

	echo "0" > /sys/class/gpio/gpio"$GPIO"/value
	echo "toggling ... 0"
	sleep 1
done
