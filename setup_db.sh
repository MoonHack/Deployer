#!/bin/bash -e
_CAT=db
source shared.sh

setup

run 'apt -y install mongodb-server'
run 'systemctl enable mongodb && systemctl restart mongodb'

finish_setup
