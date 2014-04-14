#!/usr/bin/env python
import os
import re

mask = re.compile('[\n\t\r]')
check90 = float(mask.sub("", os.popen("uptime | sed 's/.*://; s/, / /g' | awk '{print $2}'").read()))

if (check90 < 1.7):
    os.system('wmiir xwrite /rbar/status90 colors "#000 #fc5 #000"')
else:
    os.system('wmiir xwrite /rbar/status90 colors "#000 #c66 #000"')
