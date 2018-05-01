#!/bin/bash

###################
#                 #
#   Change MAC    #
#                 #
###################

networkToReset="Wi-Fi,"

interface_name=`networksetup -listnetworkserviceorder | grep Wi-Fi, | cut -d ":" -f3 | tr -d ' ' | cut -c -3`

new_mac=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`

curr_mac=`ifconfig en0 | grep ether | cut -d " " -f2`

echo "Current mac address is: ${curr_mac}"
echo "Trying to update the new mac address as: ${new_mac}"

echo "Shutting down interface ${interface_name}..."
echo "Resetting the network and updating the new MAC..."

sudo ifconfig ${interface_name} ether ${new_mac}
sudo ifconfig ${interface_name} down
sudo ifconfig ${interface_name} up

upd_mac=`ifconfig en0 | grep ether | cut -d " " -f2`

#Check if the update was successful
if [[ ${upd_mac} == ${curr_mac} ]];
then
	echo "Failed to update the mac address, something wrong with the config?"
	echo "Curr MAC: ${curr_mac} is same as Updated MAC: ${upd_mac}"
else
	echo ${upd_mac} >> ./mac_addr_history.txt
	echo "Updated MAC address, now current MAC address is: ${upd_mac}"
fi
