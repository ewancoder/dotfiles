#!/bin/bash
for i in 1 2 3 4 5; do
xfreerdp3 /v:192.168.2.2 /u:'Ivan Zyranau' /d:'' /p:$RDP_PASSWORD +compression +clipboard +fonts /dynamic-resolution +async-channels +async-update +auto-reconnect /bpp:16 /gfx:progressive /gfx && break; done
