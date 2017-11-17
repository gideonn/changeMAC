#!/bin/bash

###################
#                 #
#   Change MAC    #
#                 #
###################

interface_name=`ip link | grep -v lo | grep "mtu" | cut -d ":" -f2 | tr -d ' '`
new_mac=`tr -dc A-F0-9 < /dev/urandom | head -c 10 | sed -r 's/(..)/\1:/g;s/:$//;s/^/02:/'`
curr_mac=`ip link | grep -v lo | grep "link" | sed -e 's/^[[:space:]]*//g' | cut -d " " -f2`

echo "Current mac address is: ${curr_mac}"

echo "Shutting down interface ${interface_name}"

ifconfig ${interface_name} down
ifconfig ${interface_name} hw ether ${new_mac}
ifconfig ${interface_name} up

echo "Resetting network manager to fill routing table, please wait..."
sudo /etc/init.d/network-manager restart

sleep 10

upd_mac=`ip link | grep -v lo | grep "link" | sed -e 's/^[[:space:]]*//g' | cut -d " " -f2`
if [[ "${upd_mac}" == "${curr_mac}" ]];
then
	echo "Failed to update the mac address, did you use sudo ?"
else
	echo ${upd_mac} >> mac_addr_history.txt
	echo "Updated mac address, now current mac address is: ${upd_mac}"
fi
