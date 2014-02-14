#!/bin/bash
# Reference:
# 1) http://www.cyberciti.biz/faq/linux-traffic-shaping-ftp-server-port-21-22/
# 2) http://lartc.org/howto/lartc.qdisc.classful.html

if [ $# -lt 2 ]
then
        echo "Usage : $0 [r1|r2|r3] port"
        exit
fi


TC=/sbin/tc
IPTABLES=/sbin/iptables
DEV=eth1

FLOW_ID=1:10
PORT=$2

case "$1" in
	r1) FLOW_ID="1:10"
	    ;;	
	r2) FLOW_ID="1:20"
	    ;;
	r3) FLOW_ID="1:30"
	    ;;
	*)  FLOW_ID="1:30"
	    ;;
esac

cmd="$TC filter add dev $DEV protocol ip parent 1:0 prio 1 u32 \
	match ip sport $PORT 0xffff \
	flowid $FLOW_ID"

echo $cmd
$cmd
