#!/bin/bash -e
_CAT=runner
source shared.sh

run 'cd /opt/Runner && git pull'
scp 'Runner/config.lua' "$LOGIN:/opt/Runner/src/lua/config.lua"
scp 'Runner/config.h' "$LOGIN:/opt/Runner/src/c/config.h"
run 'cd /opt/Runner/build && cmake -DCMAKE_BUILD_TYPE=Release .. && make'
scp 'Runner/mh_runner.service' "$LOGIN:/etc/systemd/system/mh_runner.service"
run 'systemctl daemon-reload && systemctl enable mh_runner && systemctl restart mh_runner'
