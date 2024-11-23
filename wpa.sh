#!/usr/bin/bash

#
# Script to setup configurarion file for wireless WAN (client mode)
# can pass no args (defaults to sys), 1 arg (for open network) or 2 (ssid/password)
#


wlp=$(ip link show | grep -o 'wlp[[:alnum:]]*' | sort | head -n1)
echo "Wireless device is: $wlp"

if [ "$#" -eq 0 ]; then

    # if no command line args given
    echo "Defaulting to sys"
    wpa_passphrase sys Raymond7.SYS > $wlp

elif [ "$#" -eq 1 ]; then

    # use ssid (no password/open network)
    echo "Using $1 (open network)"
    cat<<EOF>$wlp
network={
    ssid="$1"
    key_mgmt=NONE
}
EOF

else

    # use ssid / password if given
    echo "Using $1:$2"
    wpa_passphrase $1 $2 > $wlp

fi

