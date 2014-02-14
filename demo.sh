#!/bin/bash

counter=0
target_counter=20
return_value=""
DEV=eth1

R_old=0
T_old=0

network_status(){
        R=`cat /sys/class/net/$DEV/statistics/rx_bytes`
        T=`cat /sys/class/net/$DEV/statistics/tx_bytes`

        TBPS=`expr $T - $T_old`
        RBPS=`expr $R - $R_old`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        echo "tx $DEV: $TKBPS kb/s rx $DEV: $RKBPS kb/s"

	R_old=$R
	T_old=$T
}

print_status(){
	echo "---------------------------"
        date
        echo "---------------------------"
	tasks=`netstat -at | grep myhost1:[^ssh] | tr -s ' ' | cut -d' ' -f4`
	for line in $tasks; do
                netstat -at | grep $line
        done
	network_status
}

# step 1 - initial rule
port_list=`netstat -at | grep myhost1:[^ssh] | tr -s ' ' | cut -d' ' -f4 | cut -d':' -f2`
for port in $port_list; do
	bash mytc_setup.sh r1 $port
done

while x=0; do
	
	if [ $counter -eq $target_counter ]; then
		bash mytc_init.sh
		port_list=`netstat -at | grep myhost1:[^ssh] | tr -s ' ' | cut -d' ' -f4 | cut -d':' -f2`
		for port in $port_list; do
			bash mytc_setup.sh r2 $port
		done
	fi

	print_status

	counter=$[counter+1]
	sleep 1
done
