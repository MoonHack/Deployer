#!/bin/bash -e
_CAT=web
source shared.sh

setup

run 'curl -sL https://deb.nodesource.com/setup_8.x | bash -'
run 'apt -y install nginx nodejs'
scp 'Web/ssl.pem' "$LOGIN:/etc/nginx/ssl.pem"
scp 'Web/mh_web.conf' "$LOGIN:/etc/nginx/conf.d/mh_web.conf"
run 'chmod 400 /etc/nginx/ssl.pem'
run 'systemctl enable nginx && systemctl restart nginx'

run 'useradd web || true'
run 'cd /opt/Web && git pull' || run 'cd /opt && git clone git@gitlab.com:MoonHack/Web'
scp 'Web/config.ts' "$LOGIN:/opt/Web/src/config.ts"
run 'cd /opt/Web && npm install -s && npm run build -s'
scp 'Web/mh_web.service' "$LOGIN:/etc/systemd/system/mh_web.service"
run 'systemctl daemon-reload && systemctl enable mh_web && systemctl restart mh_web'

finish_setup
