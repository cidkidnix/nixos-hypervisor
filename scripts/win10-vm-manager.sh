#!/usr/bin/env bash
while :
do
         test=`virsh list --all | grep win10-amd | grep -o "shut off"`
         test1=`virsh list --all | grep win10-amd | grep -o "running"`
         if [[ $test == "shut off" ]]
                then
			echo "RESTARTING VM"
                        sleep 2
                        setpci -s "0000:29:00.0" 7c.l=39d5e86b
                        echo "SET PCI VALUE"
			sleep 5
                        virsh start win10-amd
                        echo "VM RESTARTED"
                else
                        sleep 1
                fi
done
