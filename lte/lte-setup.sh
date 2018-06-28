#!/usr/bin/env bash

PIN=2175

set-gpio 113 0
set-gpio 115 0
set-gpio 59 1
set-gpio 115 1
modprobe qmi_wwan

ATTEMPT=0
while [ $ATTEMPT -lt 100 ]; do
	if [[ `qmicli -d /dev/cdc-wdm0 --uim-verify-pin=PIN1,"$PIN"` ]]; then
		while [ `qmi-network /dev/cdc-wdm0 start` != *"Network started successfully"* ]; do
			echo "failed to setup LTE network"
			sleep 1
		done
		udhcpc -i wwan0
		exit 0
	else
		echo "failed to setup LTE modem"
	fi

	let ATTEMPT=ATTEMPT+1
	sleep 1
done

exit 1
