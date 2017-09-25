# This file must be sourced, never ran!

set -e

IP="$1"
LOGIN="root@$IP"
HOSTNAME="$_CAT$2.moonhack.net"
run() {
	ssh -oForwardAgent=yes "$LOGIN" "$@"
}
finish() {
	run 'echo Done'
	#run reboot
}
ssh-copy-id "root@$IP"

run 'touch ~/.ssh/known_hosts'
run 'ssh-keyscan gitlab.com 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts'
run 'mv ~/.ssh/tmp_hosts ~/.ssh/known_hosts'

run 'apt -y update && apt -y upgrade'
run 'apt -y install sudo htop screen tcpdump git'
run "hostnamectl set-hostname $HOSTNAME"
run 'timedatectl set-timezone UTC'
