#!/bin/bash -e
_CAT=runner
source shared.sh

run 'cd /home/runner/Runner && git pull'
scp 'Runner/config.lua' "$LOGIN:/home/runner/Runner/src/lua/config.lua"
scp 'Runner/config.h' "$LOGIN:/home/runner/Runner/src/c/config.h"
run 'cd /home/runner/Runner/build && cmake -DCMAKE_BUILD_TYPE=Release .. && make'
scp 'Runner/mh_runner.service' "$LOGIN:/etc/systemd/system/mh_runner.service"
run 'systemctl daemon-reload && systemctl enable mh_runner && systemctl restart mh_runner'

