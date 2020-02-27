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
		#set-gpio 115 1

		ATTEMPT=0
		while [ $ATTEMPT -lt 100 ]; do
			#STATUS=`qmicli -d /dev/cdc-wdm0 --uim-get-card-status`
			STATUS="""Successfully got card status
			Provisioning applications:
        Primary GW:   slot '1', application '1'  
        Primary 1X:   session doesn't exist
        Secondary GW: session doesn't exist
        Secondary 1X: session doesn't exist
Slot [1]:
        Card state: 'present'
        UPIN state: 'not-initialized'
                UPIN retries: '0'
                UPUK retries: '0'
        Application [1]:
                Application type:  'usim (2)'
                Application state: 'ready'
                Application ID:
                        A0:00:00:00:87:10:02:FF:49:FF:05:89
                Personalization state: 'ready'
                UPIN replaces PIN1: 'no'
                PIN1 state: 'disabled'
                        PIN1 retries: '3'
                        PUK1 retries: '10'
                PIN2 state: 'enabled-not-verified'
                        PIN2 retries: '3'
                        PUK2 retries: '10'"""

			if [[ "$STATUS" == *"Successfully got card status"* ]]; then
				RETRIES=`echo "$STATUS" | grep -A 12 'Application \[0\]:' | grep -o 'PIN1 retries: [^,]*' | cut -d':' -f2- | tr -dc '0-9'`
				if [[ "$RETRIES" < 3 ]]; then
					echo "Less than 3 PIN retries! Aborting ..."
					exit 1
				fi
				exit =
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
