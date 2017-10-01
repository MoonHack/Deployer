# This file must be sourced, never ran!

set -e

IP="$1"
LOGIN="root@$IP"
run() {
	ssh -oForwardAgent=yes "$LOGIN" "$@"
}
finish_setup() {
	run reboot
}
ssh-copy-id "root@$IP"

setup() {
	HOSTNAME="$_CAT$2.moonhack.net"

	run 'touch ~/.ssh/known_hosts'
	run 'ssh-keyscan gitlab.com 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts'
	run 'mv ~/.ssh/tmp_hosts ~/.ssh/known_hosts'

	run 'echo "@reboot /sbin/iptables-restore < /root/iptables.rules" > /ct && crontab /ct && rm -f /ct'

	run 'apt -y install sudo htop screen tcpdump git curl iptables ntp haveged rsync'
	run "hostnamectl set-hostname $HOSTNAME"
	run 'timedatectl set-timezone UTC'

	scp eth1intf "$LOGIN:/etc/network/interfaces.d/eth1intf"
}

run 'apt -y update && apt -y upgrade'
