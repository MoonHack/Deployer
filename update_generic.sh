#!/bin/bash -e
source shared.sh
scp eth1intf "$LOGIN:/etc/network/interfaces.d/eth1intf"
run 'reboot'
