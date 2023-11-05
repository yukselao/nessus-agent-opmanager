#!/bin/bash

cd /tmp
dpkg -i NessusAgent-10.4.2-ubuntu1404_amd64.deb
/opt/nessus_agent/sbin/nessuscli fix --secure --get ms_cert
/opt/nessus_agent/sbin/nessuscli agent link --key=$1 --name=$2 --groups="$3" --host=$4 --port=$5
/opt/nessus_agent/sbin/nessuscli agent status
