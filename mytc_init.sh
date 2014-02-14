#!/bin/bash
# Reference:
# 1) http://www.cyberciti.biz/faq/linux-traffic-shaping-ftp-server-port-21-22/
# 2) http://lartc.org/howto/lartc.qdisc.classful.html

TC=/sbin/tc
IPTABLES=/sbin/iptables
DEV=eth1

# create hierarchical queues 
$TC qdisc del dev $DEV root
$TC qdisc add dev $DEV root handle 1: htb default 30
$TC class add dev $DEV parent 1: classid 1:1 htb rate 1000mbit burst 15k

# bandwidth classes
$TC class add dev $DEV parent 1:1 classid 1:10 htb rate 50mbit burst 15k
$TC class add dev $DEV parent 1:1 classid 1:20 htb rate 100mbit ceil 500mbit burst 15k
$TC class add dev $DEV parent 1:1 classid 1:30 htb rate 100mbit ceil 1000mbit burst 15k

# use fairness queue
$TC qdisc add dev $DEV parent 1:10 handle 10: sfq perturb 10
$TC qdisc add dev $DEV parent 1:20 handle 20: sfq perturb 10
$TC qdisc add dev $DEV parent 1:30 handle 30: sfq perturb 10
