#!/usr/bin/env python
import data as s

#========== CONFIGURATION ==========

#=== COLORS ===
FocusColors = "#000 #fc5 #000"
SoundColors = "#000 #6cc #000"
GoodColors = "#000 #6c6 #000"
MidColors = "#000 #7c8 #000"
BadColors = "#000 #c66 #000"

#=== STATUSBAR ===
#Free RAM
s.text = "echo $(free -mh | grep /cache | awk '{print $4}') 'M'"
s.check = "free -m | grep /cache | awk '{print $4}'"
s.bigger = 3000
s.mid = 1000
s.addBlock()
#Space at /
s.text = "echo $(df -h / | grep / | awk '{print $5}' | sed 's/%//') '/'"
s.check = "df -h / | grep / | awk '{print $5}' | sed 's/%//'"
s.lower = 45
s.mid = 75
s.addBlock()
#Space at /home
s.text = "echo $(df -h /home | grep home | awk '{print $5}' | sed 's/%//') 'H'"
s.check = "df -h /home | grep home | awk '{print $5}' | sed 's/%//'"
s.lower = 45
s.mid = 75
s.addBlock()
#Space at /mnt/cloud
s.text = "echo $(df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//') 'C'"
s.check = "df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//'"
s.lower = 45
s.mid = 75
s.addBlock()
#Space at /mnt/backup
s.text = "echo $(df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//') 'B'"
s.check = "df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//'"
s.lower = 45
s.mid = 75
s.addBlock()
#CPU Temperature
s.text = "sensors | grep -m 1 temp1 | awk '{print $2}' | cut -c 2-3"
s.check = s.text
s.lower = 40
s.mid = 50
s.addBlock()
#CPU Frequency
s.text = "cat /proc/cpuinfo | grep -m 1 MHz | awk '{printf \"%.0f\\n\", $4}'"
s.addBlock()
#GPU Temperature
s.text = "nvidia-settings -q=GPUCoreTemp | grep -m 1 ewanhost | awk '{print $4}' | cut -c1-2"
s.check = s.text
s.lower = 40
s.mid = 52
s.addBlock()
#Sound Volume
s.text = "amixer | grep \"Left: Playback\" | awk {'print $5'} | cut -d \"[\" -f2 | cut -d \"%\" -f1"
s.color = SoundColors
s.addBlock()
#CPU Uptime
s.text = "uptime | sed 's/.*://; s/, / /g'"
s.check = s.text + " | awk '{print $2}'"
s.color = FocusColors
s.lower = 1.75
s.addBlock()
