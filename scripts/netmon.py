#!/usr/bin/env python
import os
import re

mask = re.compile('[\n\t\r]')

BYTES = 2 * 1024

def get(command):
    return float(mask.sub('', os.popen(command).read()))

def update():
    os.system("ifconfig enp2s0 | grep RX\ packets | awk '{print $5}' > /tmp/rx")
    os.system("ifconfig enp2s0 | grep TX\ packets | awk '{print $5}' > /tmp/tx")

def getnew():
    rx_new = get("ifconfig enp2s0 | grep RX\ packets | awk '{print $5}'")
    tx_new = get("ifconfig enp2s0 | grep TX\ packets | awk '{print $5}'")
    return (rx_new, tx_new)

def updown():
    if os.path.isfile('/tmp/rx') and os.path.isfile('/tmp/tx'):
        rx_old = get('cat /tmp/rx')
        tx_old = get('cat /tmp/tx')
        rx_new, tx_new = getnew()
        update()
        return (
                str("{:.0f}".format((rx_new - rx_old)/BYTES)),
                str("{:.0f}".format((tx_new - tx_old)/BYTES))
        )
    else:
        update()
        updown()

print(updown()[0], updown()[1])
