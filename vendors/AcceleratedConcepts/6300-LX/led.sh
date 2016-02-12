#!/bin/sh
#
# take care of 6300-CX/6300-LX specific LED setting
#
##############################################################
# allow script override
[ -x /etc/config/led.sh ] && exec /etc/config/led.sh "$@"
##############################################################
#exec 2>> /tmp/led.log
#set -x

usage()
{
	[ "$1" ] && echo "$1"
	echo "usage: $0 <interface_lan|interface_modem|signal|rat> <setup|teardown|up|down>"
	exit 1
}

##############################################################
#
# get our tools
#

source /usr/share/libubox/jshn.sh

##############################################################
#
# start with modem state,  assume CX/LX will always have a modem in proper
# operation
#
# CELL 0=not there, 1=starting, 2=2G/3G, 3=LTE
#

CELL=0 # not-valid, never going to work
STATUS=$(ubus call network.interface.interface_modem status 2> /dev/null)
if [ "$?" = 0 ]; then
	eval $(jshn -r "$STATUS" 2> /dev/null)
	json_get_var pending "pending"
	json_get_var up "up"
	[ "${pending:-0}" -eq 1 ] && CELL=1
	[ "${up:-0}" -eq 1 ] && CELL=2
	[ "$CELL" -eq 2 -a -f /tmp/modem_is_4g ] && CELL=3
fi

#
# now do ethernet,  we always have ethernet even if not plugged in
# LAN 0=not there, 1=starting, 2=up,  if neither the ip4 or ipv6
# interfaces are present we must be in passthrough mode,  assume
# the LAN is up for now as this is what the older version of led.sh
# did and everyone was happy with the LED's there.
#

LAN4=-1
STATUS=$(ubus call network.interface.ipv4_interface_lan status 2> /dev/null)
if [ "$?" = 0 ]; then
	LAN4=0
	eval $(jshn -r "$STATUS" 2> /dev/null)
	json_get_var pending "pending"
	json_get_var up "up"
	[ "${pending:-0}" -eq 1 ] && LAN4=1
	[ "${up:-0}" -eq 1 ] && LAN4=2
fi

LAN6=-1
STATUS=$(ubus call network.interface.ipv6_interface_lan status 2> /dev/null)
if [ "$?" = 0 ]; then
	LAN6=0
	eval $(jshn -r "$STATUS" 2> /dev/null)
	json_get_var pending "pending"
	json_get_var up "up"
	[ "${pending:-0}" -eq 1 ] && LAN6=1
	[ "${up:-0}" -eq 1 ] && LAN6=2
fi

# if neither interface exists force the LAN to be up (ie., passthrough)
[ "$LAN4" -eq -1 -a "$LAN6" -eq -1 ] && LAN4=2

if [ "$LAN4" -eq 2 -o "$LAN6" -eq 2 ]; then
	LAN=2
elif [ "$LAN4" -eq 1 -o "$LAN6" -eq 1 ]; then
	LAN=1
else
	LAN=0
fi

#
# The LED table of things based on all possible values above
#
LED00="-f COM -O ONLINE -f ETH" # flashing yellow
LED10="-f COM -O ONLINE -f ETH" # flashing yellow
LED20="-O COM -O ONLINE -f ETH" # flashing green
LED30="-O COM -f ONLINE -O ETH" # flashing blue
LED01="-f COM -O ONLINE -f ETH" # flashing yellow
LED11="-f COM -O ONLINE -f ETH" # flashing yellow
LED21="-O COM -O ONLINE -f ETH" # flashing green
LED31="-O COM -f ONLINE -O ETH" # flashing blue
LED02="-f COM -f ONLINE -f ETH" # flashing white
LED12="-f COM -f ONLINE -f ETH" # flashing white
LED22="-O COM -O ONLINE -o ETH" # solid green
LED32="-O COM -o ONLINE -O ETH" # solid blue

##############################################################

eth_led()
{
	eval ledcmd \$LED$CELL$LAN
}

modem_led()
{
	eval ledcmd \$LED$CELL$LAN
	# if cell is bad,  ensure signal strength is reset
	[ "$CELL" = "0" ] && signal_led 0
}

signal_led()
{
	case "$1" in
		5) sig="-o RSS1 -o RSS2 -o RSS3 -o RSS4 -o RSS5" ;;
		4) sig="-o RSS1 -o RSS2 -o RSS3 -o RSS4 -O RSS5" ;;
		3) sig="-o RSS1 -o RSS2 -o RSS3 -O RSS4 -O RSS5" ;;
		2) sig="-o RSS1 -o RSS2 -O RSS3 -O RSS4 -O RSS5" ;;
		1) sig="-o RSS1 -O RSS2 -O RSS3 -O RSS4 -O RSS5" ;;
		*) sig="-O RSS1 -O RSS2 -O RSS3 -O RSS4 -O RSS5" ;;
	esac
	eval ledcmd $sig \$LED$CELL$LAN
}

firmware_led()
{
	case "$1" in
	start) ledcmd -a -n COM -n ETH -n ONLINE -o COM -f ETH -O ONLINE ;;
	stop)  ledcmd -a -N COM -N ETH -N ONLINE ;;
	esac
}

rat_led()
{
	case "$1" in
	4g) touch /tmp/modem_is_4g ;;
	*)  rm -f /tmp/modem_is_4g ;;
	esac
	# we need to recalc CELL if RAT changes
	[ "$CELL" -eq 2 -a -f /tmp/modem_is_4g ] && CELL=3
	[ "$CELL" -eq 3 -a ! -f /tmp/modem_is_4g ] && CELL=2
	eval ledcmd \$LED$CELL$LAN
}

sim_led()
{
	:
}

##############################################################

[ $# -ne 2 ] && usage "Wrong number of arguments"

CMD="$1"
shift

case "$CMD" in
*interface_lan*)   eth_led    "$@" ;;
*interface_modem*) modem_led  "$@" ;;
signal*)           signal_led "$@" ;;
rat*)              rat_led    "$@" ;;
sim*)              sim_led    "$@" ;;
firmware*)         firmware_led "$@" ;;
*)                 exit 1 ;;
esac

exit 0
