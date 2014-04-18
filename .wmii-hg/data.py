#!/usr/bin/env python
#Arrays & Variables definition
block = []
global text, color, check, lower, bigger, mid, midColor, badColor
text, color, check, lower, bigger, mid, midColor, badColor = "", "", "", "", "", "", "", ""

#Setup a block
def setup():
    global text, color, check, lower, bigger, mid, midColor, badColor
    x = len(block)
    #Generate name for block
    if x < 10:
        name = "Status_a"+str(x)
    else:
        name = "Status_b"+str(x) #This is it, noone needs 30+ statusbars
    #Create new block
    block.append([])
    block[x].extend((name, text, color, check, lower, bigger, mid, midColor, badColor))
    text, color, check, lower, bigger, mid, midColor, badColor = "", "", "", "", "", "", "", ""

#========== CONFIGURATION ==========

#Colors
FocusColors = "#000 #fc5 #000"
SoundColors = "#000 #6cc #000"
GoodColors = "#000 #6c6 #000"
MidColors = "#000 #7c8 #000"
BadColors = "#000 #c66 #000"

#Free RAM
text = "echo $(free -mh | grep /cache | awk '{print $4}') 'M'"
check = "free -m | grep /cache | awk '{print $4}'"
bigger = 3000
mid = 1000
setup()
#Space at /
text = "echo $(df -h / | grep / | awk '{print $5}' | sed 's/%//') '/'"
check = "df -h / | grep / | awk '{print $5}' | sed 's/%//'"
lower = 45
mid = 75
setup()
#Space at /home
text = "echo $(df -h /home | grep home | awk '{print $5}' | sed 's/%//') 'H'"
check = "df -h /home | grep home | awk '{print $5}' | sed 's/%//'"
lower = 45
mid = 75
setup()
#Space at /mnt/cloud
text = "echo $(df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//') 'C'"
check = "df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//'"
lower = 45
mid = 75
setup()
#Space at /mnt/backup
text = "echo $(df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//') 'B'"
check = "df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//'"
lower = 45
mid = 75
setup()
#CPU Temperature
text = "sensors | grep -m 1 temp1 | awk '{print $2}' | cut -c 2-3"
check = text
lower = 40
mid = 50
setup()
#CPU Frequency
text = "cat /proc/cpuinfo | grep -m 1 MHz | awk '{printf \"%.0f\\n\", $4}'"
setup()
#GPU Temperature
text = "nvidia-settings -q=GPUCoreTemp | grep -m 1 ewanhost | awk '{print $4}' | cut -c1-2"
check = text
lower = 40
mid = 52
setup()
#Sound Volume
text = "amixer | grep \"Left: Playback\" | awk {'print $5'} | cut -d \"[\" -f2 | cut -d \"%\" -f1"
color = SoundColors
setup()
#CPU Uptime
text = "uptime | sed 's/.*://; s/, / /g'"
check = text + " | awk '{print $2}'"
color = FocusColors
lower = 1.75
setup()
