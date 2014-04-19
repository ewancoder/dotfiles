#!/usr/bin/env python
import data as d

#========== CONFIGURATION ==========

#=== STARTUP ===
#Background
d.startup("~/.dotfiles/scripts/pic ~/Dropbox/Pictures 300")
#Run RSS curses-based client
d.startup("urxvt -name Canto -e canto-curses")

#Unmute pulseaudio after fresh reinstall
d.startup("~/runonce.sh")
#Run chromium in background
d.startup("chromium --no-startup-window")
#Run copy daemon
d.startup("copy")
#Run deluge gtk-based client
d.startup("deluge")
#Run dropbox daemon
d.startup("dropboxd")
#Run locales icon in tray
d.startup("gxkb")
#Run kalu - update checker
d.startup("kalu")
#Run tilda - overall F12 guake-style terminal
d.startup("tilda")

#=== COLORS ===
#Color of focused tag/window
FocusColors = "#000 #fc5 #000"
#Color of sound block (see below)
SoundColors = "#000 #6cc #000"
#Good, Mid & Bad colors for checking state and drawing status
GoodColors = "#000 #6c6 #000"
MidColors = "#000 #7c8 #000"
BadColors = "#000 #c66 #000"

#=== COLUMN RULES ===
#For skype mini-window on the left side
d.addColRule(0, "20+80")
#For two Thunars / 2 chromium windows
d.addColRule(2, "50+50")
#For anything else - Golden Ratio
d.addColRule(".*", "62+38")

#=== TAGGING RULES ===
#For canto-curses urxvt 'Canto' window
d.addTagRule("Canto", "RSS")
#For Skype to be at 0 :)
d.addTagRule("Skype", 0)
#For separate steam big-picture tag
d.addTagRule("Steam", "Steam")

#=== STATUSBAR ===
#Time
d.time = "date +%a\\ %b\\ %d\\ %T\\"
#Free RAM
d.text = "echo $(free -mh | grep /cache | awk '{print $4}') 'M'"
d.check = "free -m | grep /cache | awk '{print $4}'"
d.bigger = 3000
d.mid = 1000
d.addBlock()
#Space at /
d.text = "echo $(df -h / | grep / | awk '{print $5}' | sed 's/%//') '/'"
d.check = "df -h / | grep / | awk '{print $5}' | sed 's/%//'"
d.lower = 45
d.mid = 75
d.addBlock()
#Space at /home
d.text = "echo $(df -h /home | grep home | awk '{print $5}' | sed 's/%//') 'H'"
d.check = "df -h /home | grep home | awk '{print $5}' | sed 's/%//'"
d.lower = 45
d.mid = 75
d.addBlock()
#Space at /mnt/cloud
d.text = "echo $(df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//') 'C'"
d.check = "df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//'"
d.lower = 45
d.mid = 75
d.addBlock()
#Space at /mnt/backup
d.text = "echo $(df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//') 'B'"
d.check = "df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//'"
d.lower = 45
d.mid = 75
d.addBlock()
#CPU Temperature
d.text = "sensors | grep -m 1 temp1 | awk '{print $2}' | cut -c 2-3"
d.check = d.text
d.lower = 40
d.mid = 50
d.addBlock()
#CPU Frequency
d.text = "cat /proc/cpuinfo | grep -m 1 MHz | awk '{printf \"%.0f\\n\", $4}'"
d.addBlock()
#GPU Temperature
d.text = "nvidia-settings -q=GPUCoreTemp | grep -m 1 ewanhost | awk '{print $4}' | cut -c1-2"
d.check = d.text
d.lower = 40
d.mid = 52
d.addBlock()
#Sound Volume
d.text = "amixer | grep \"Left: Playback\" | awk {'print $5'} | cut -d \"[\" -f2 | cut -d \"%\" -f1"
d.color = SoundColors
d.addBlock()
#CPU Uptime
d.text = "uptime | sed 's/.*://; s/, / /g'"
d.check = d.text + " | awk '{print $2}'"
d.color = FocusColors
d.lower = 1.75
d.addBlock()
