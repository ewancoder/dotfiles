#!/bin/bash
xfreerdp3 /audio-mode:0 /cert:ignore /auth-pkg-list:'!kerberos' /v:192.168.1.185 /u:"$N_RDP_USERNAME" /d:'' /p:"$N_RDP_PASSWORD" +compression +clipboard +fonts /dynamic-resolution +async-channels +async-update +auto-reconnect /bpp:16 /gfx:progressive /gfx
