#!/usr/bin/env bash

case "$1" in
	-h|--help)
		echo "lte-modem --pin 1234 up"
		echo "lte-modem down"
		exit 0
		;;
	-p|--pin)
		PIN="$2"
		if [[ "$3" != "up" ]]; then
			echo "Unsupported!"
			echo "Try --help"
			exit 1
		fi
		
		echo "start LTE network"
		set-gpio 115 1

		ATTEMPT=0
		while [ $ATTEMPT -lt 100 ]; do
			STATUS=`qmicli -d /dev/cdc-wdm0 --uim-get-card-status`

			if [[ "$STATUS" == *"Successfully got card status"* ]]; then
				RETRIES=`echo "$STATUS" | grep -o 'PIN1 retries: [^,]*' | cut -d':' -f2- | tr -dc '0-9'`
				if [[ "$RETRIES" < 3 ]]; then
					echo "Less than 3 PIN retries! Aborting ..."
					exit 1
				fi
				
				if [[ "$PIN" != "none" ]]; then
					PINSTATUS=`qmicli -d /dev/cdc-wdm0 --uim-verify-pin=PIN1,"$PIN"`
					if [[ "$PINSTATUS" != *"PIN verified successfully"* ]]; then
						echo "Incorrect PIN! Aborting ..."
						exit 1
					fi
				fi
				
				while [[ `qmi-network /dev/cdc-wdm0 start` != *"Network started successfully"* ]]; do
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
		;;
	"down")
		echo "stop LTE network"
		ifconfig wwan0 down
		qmi-network /dev/cdc-wdm0 stop
		set-gpio 115 0
		;;
	*)
		echo "Unsupported!"
		echo "Try --help"
		exit 1
		;;
esac
