#!/bin/bash -e
_CAT=runner
source shared.sh

run 'apt -y install libssl-dev libluajit-5.1-dev luajit luarocks build-essential cmake librabbitmq-dev uuid-dev'
run 'useradd runner || true'
run 'mkdir -p /home/runner && chown runner:runner /home/runner'
run 'cd /home/runner/Runner && git pull' || run 'cd /home/runner && git clone git@gitlab.com:MoonHack/Runner'
scp 'Runner/config.lua' "$LOGIN:/home/runner/Runner/src/lua/config.lua"
scp 'Runner/config.h' "$LOGIN:/home/runner/Runner/src/c/config.h"
run 'cd /home/runner/Runner/build && cmake -DCMAKE_BUILD_TYPE=Release .. && make'

finish
