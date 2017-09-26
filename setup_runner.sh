#!/bin/bash -e
_CAT=runner
source shared.sh

setup

run 'apt -y install libssl-dev libluajit-5.1-dev luajit luarocks build-essential cmake librabbitmq-dev uuid-dev'

run 'cd /usr/src && wget https://github.com/mongodb/mongo-c-driver/releases/download/1.8.0/mongo-c-driver-1.8.0.tar.gz -O mongo-c-driver-1.8.0.tar.gz && tar xzf mongo-c-driver-1.8.0.tar.gz && cd mongo-c-driver-1.8.0 && ./configure --disable-automatic-init-and-cleanup --disable-shm-counters && make && make install'

run 'luarocks install lpeg'
run 'luarocks install dkjson'
run 'luarocks install lua-mongo'
run 'luarocks install uuid'

run 'useradd runner || true'
run 'cd /opt/Runner && git pull' || run 'cd /opt && git clone git@gitlab.com:MoonHack/Runner'
scp 'Runner/config.lua' "$LOGIN:/opt/Runner/src/lua/config.lua"
scp 'Runner/config.h' "$LOGIN:/opt/Runner/src/c/config.h"
run 'cd /opt/Runner/build && cmake -DCMAKE_BUILD_TYPE=Release .. && make'
scp 'Runner/mh_runner.service' "$LOGIN:/etc/systemd/system/mh_runner.service"
run 'systemctl daemon-reload && systemctl enable mh_runner && systemctl restart mh_runner'

finish_setup
