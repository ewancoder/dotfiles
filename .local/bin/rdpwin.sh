#!/bin/bash
xfreerdp3 /cert:ignore /auth-pkg-list:'!kerberos' /v:192.168.2.2 /u:"$RDP_USERNAME" /d:'' /p:"$RDP_PASSWORD" +compression +clipboard +fonts /dynamic-resolution +async-channels +async-update +auto-reconnect /bpp:16 /gfx:progressive /gfx
