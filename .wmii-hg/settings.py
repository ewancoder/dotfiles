#========== GENERAL FUNCTIONS ==========
global blocks
blocks = []
global colRules, tagRules
colRules, tagRules = '', ''
global text, name, check, lower, bigger, mid, color
text, name, check, lower, bigger, mid, color = '', '', '', '', '', '', ''

def addBlock():
    global blocks
    global text, name, check, lower, bigger, mid, color
    x = len(blocks)
    #Generate name for block
    if x < 10:
        name = 'Status_a' + str(x)
    elif x < 20:
        name = 'Status_b' + str(x-10)
    else:
        name = 'Status_c' + str(x-20)
    #Create new block
    blocks.append([text, name, check, lower, bigger, mid, color])
    text, name, check, lower, bigger, mid, color = '', '', '', '', '', '', ''

#Function forming colrules
def addColRule(col, rule):
    global colRules
    colRules = colRules + '/' + str(col) + '/ -> ' + str(rule) + '\n'

#Function forming tagrules
def addTagRule(tag, forcetag):
    global tagRules
    tagRules += '/' + str(tag) + '/ tags=' + str(forcetag) + '\n'

#========== CONFIGURATION ==========

#=== COLORS ===
goodColors = '#ada #350 #000' #Focused + Good
normColors = goodColors.split()[0] + ' #000 #000' #Not-focused window
tagFocusColors = '#fc5 #730 #000' #Focused Tag
midColors = '#dda ' + goodColors.split()[1] + ' #000' #Medium status
badColors = '#daa #600 #000' #Bad Status
warnColors = '#faa #c00 #f44' #For Warnings
#Devices and GIT colors
deviceColors = '#ada #b42 #000'
gitColors = '#f63 #000 #000'
gitBlueColors = '#36f #000 #000'
gitGreenColors = '#6f6 #000 #000'
#Alternative color - for noticebar
altColors = '#aad #000 #000'
#AM/PM
amColors = '#ee8 ' + goodColors.split()[1] + ' #000'
pmColors = '#8e8 ' + goodColors.split()[1] + ' #000'
#Sound device indication
speakerColors = altColors.split()[0] + ' ' + goodColors.split()[1] + ' #000'

#=== GENERAL CONFIG ===
modkey = 'Mod4'
up = 'k'
down = 'j'
left = 'h'
right = 'l'

font = '-*-*-medium-r-*-*-12-*-*-*-*-*-*-*'
term = 'urxvt'
border = 1

#Panel position (top or bottom)
position = 'top'

#Background folder
background = '~/Dropbox/Pictures'
#Timeout to change background, in seconds

#Timeouts (in seconds)
bgTimeout = 300
eventsTimeout = 5
statusTimeout = 2
updatesTimeout = 600

#Startup X11 apps
startup = [
    'gxkb',
    'dropbox',
    'megasync',
    'ssh -fNL 7070:127.0.0.1:7070 root@`cat ~/.rpi`',
    'tilda',
    'chromium --no-startup-window'
]
#Events are executed each 5 seconds
events = [
    '~/bin/unarchive',
    '~/bin/ircnotify'
]

#=== COLUMN RULES ===
#For two Thunars / 2 chromium windows
addColRule(2, "50+50")
#For anything else - Golden Ratio
addColRule(".*", "62+38")

#=== TAGGING RULES ===
#For Skype to be at 0 :)
addTagRule("Skype", 0)
#For separate steam big-picture tag
addTagRule("Steam", "Steam")
#VLC
addTagRule("vlc", "sel+0")
#PopcornTime
addTagRule("Popcorn-Time", 9)

#Time format
time = "date +%a\\ %b\\ %d\\ %I:%M:%S\\ %p"

#=== PRE-STATUSBAR ===
#Pulseaudio sinks
text = "~/bin/mypo | awk -F '|' '!/Active/ {print \" \"$2\" \"}; /Active/ {print \" [\"$2\"] \"}'"
color = goodColors
addBlock()
#Kernel
text = 'uname -r'
color = altColors
addBlock()
#GIT activity
text = "~/bin/gitch | awk '/Unstaged/ {print $2}'"
color = gitColors
addBlock()
text = "~/bin/gitch | awk '/Ahead/ {print $2}'"
color = gitBlueColors
addBlock()
text = "~/bin/gitch | awk '/Staged/ {print $2}'"
color = gitGreenColors
addBlock()
#Removable USB
text = 'ls -1 /media | tr "\\n" " "'
color = deviceColors
addBlock()
#USB backup
text = 'if [ -f /tmp/usb.lock ]; then echo "Working..."; fi'
color = deviceColors
addBlock()
#Unmounting message
text = 'if ! [ "$(ps aux | grep "devmon --unmount" | grep -v grep)" == "" ]; then echo "Unmounting..."; fi'
color = deviceColors
addBlock()
#Check for cp/mv activity
text = "cv | egrep -o '[0-9]+..%' | egrep -v 'grep|cut'"
color = midColors
addBlock()

#=== STATUSBAR ===
#Free RAM
text = "echo $(top -bn1 | grep 'Mem' | awk '{print $4}' | cut -f1 -d '/')"
check = "top -bn1 | grep 'Mem' | awk '{print $4}' | cut -f1 -d '/'"
lower = 50
mid = 80
addBlock()
#Space at /
text = "echo $(df -h / | grep / | awk '{print $5}' | tr -d '%') '/'"
check = "df -h / | grep / | awk '{print $5}' | tr -d '%'"
lower = 55
mid = 80
addBlock()
#Space at /home
text = "echo $(df -h /home | grep home | awk '{print $5}' | tr -d '%') 'H'"
check = "df -h /home | grep home | awk '{print $5}' | tr -d '%'"
lower = 55
mid = 80
addBlock()
#Space at /mnt/cloud
text = "echo $(df -h /mnt/cloud | grep cloud | awk '{print $5}' | tr -d '%') 'C'"
check = "df -h /mnt/cloud | grep cloud | awk '{print $5}' | tr -d '%'"
lower = 55
mid = 75
addBlock()
#Space at /mnt/backup
text = "echo $(df -h /mnt/backup | grep backup | awk '{print $5}' | tr -d '%') 'B'"
check = "df -h /mnt/backup | grep backup | awk '{print $5}' | tr -d '%'"
lower = 55
mid = 75
addBlock()
#CPU Temperature
text = "awk '{printf \"%.0f\", $1/1000; exit}' /sys/class/hwmon/hwmon0/temp*_input"
check = text
lower = "awk '{printf \"%.0f\", $1/1400; exit}' /sys/class/hwmon/hwmon0/temp*_max"
mid = "awk '{printf \"%.0f\", $1/1200; exit}' /sys/class/hwmon/hwmon0/temp*_crit"
addBlock()
#CPU Frequency
text = "cat /proc/cpuinfo | grep -m 1 MHz | awk '{printf \"%.0f\\n\", $4}'"
addBlock()
#GPU Temperature
text = "nvidia-settings -q=GPUCoreTemp | grep -m 1 GPUCoreTemp | awk '{printf \"%.0f\\n\", $4}'"
check = text
lower = 40
mid = 52
addBlock()
#NETSTATS
text = "~/bin/netmon"
addBlock()
#CPU Uptime
text = "uptime | sed 's/.*://; s/, / /g'"
check = text + " | awk '{print $2}'"
lower = 1.95
addBlock()

#Output for wmiirc
if __name__ == "__main__":
    print("modkey|" + modkey)
    print("up|" + up)
    print("down|" + down)
    print("left|" + left)
    print("right|" + right)
    print("font|" + font)
    print("term|" + term)

    print("normColors|" + normColors)
    print("goodColors|" + goodColors) #WMII_FOCUSCOLORS
    print("tagFocusColors|" + tagFocusColors)
    print("warnColors|" + warnColors)

    print("statusTimeout|" + str(statusTimeout))
