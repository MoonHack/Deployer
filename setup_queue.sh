#!/bin/bash -e
_CAT=queue
source shared.sh

setup

run 'apt -y install rabbitmq-server'
run 'systemctl enable rabbitmq-server && systemctl restart rabbitmq-server'
run 'rabbitmq-plugins enable rabbitmq_management'

finish_setup
