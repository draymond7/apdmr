#!/bin/bash
previous_state=0

while true; do
previous_state=0

    # Find first USB network interface (with enx prefix)
    eth=$(ip link show | grep -o 'enx[[:alnum:]]*' | sort | head -n1)
    echo eth:$eth

    if [ -n "$eth" ]; then
        echo eth:$eth
        # Bring eth interface up if it is not up
        if [ "$(ip link show $eth | grep -c "UP")" -eq 0 ]; then
            ip link set $eth up
            sleep 1 # give interface time to initialize
        fi

        # read carrier only if eth interface exsis and is up
        if [ -f "/sys/class/net/$eth/carrier" ]; then
            current_state=$(cat /sys/class/net/$eth/carrier)
            echo $current_state
    
            if [ "$current_state" != "$previous_state" ] && [ "$current_state" = "1" ]; then
                /sbin/ip route del default
                /sbin/dhclient -r $eth
                /sbin/dhclient    $eth
            fi

            previous_state=$current_state
        else
            previous_state=0
        fi

    else
        # no eth interface, check for wireless config file
        wlp=$(ip link show | grep -o 'wlp[[:alnum:]]*' | sort | head -n1)
        cnf="/root/$wlp"
        echo $wlp:$cnf

        if [ -f "$cnf" ]; then
            wpa_supplicant -B -i $wlp -c $cnf

            /sbin/dhclient -r $wlp
            /sbin/dhclient    $wlp

            # remove configuration file so it doesn't run again / repeatedly
            rm $cnf

            sleep 1 # give interface time to initialize
            previous_state=1
        else
            previous_state=0
        fi
    fi

done
