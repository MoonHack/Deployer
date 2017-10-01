#!/bin/bash -e
_CAT=web
source shared.sh

run 'cd /opt/Web && git pull'
rsync -v 'Web/config.ts' "$LOGIN:/opt/Web/src/config.ts"
run 'cd /opt/Web && npm install -s && npm run build -s'
rsync -v 'Web/mh_web.service' "$LOGIN:/etc/systemd/system/mh_web.service"
run 'systemctl daemon-reload && systemctl enable mh_web && systemctl restart mh_web'
