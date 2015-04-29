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
gitGreenColors = '#6f6 #000 #000'
gitBlueColors = '#36f #000 #000'

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

#Timeouts (in seconds)
statusTimeout = 2
eventsTimeout = 5
bgTimeout = 300
updatesTimeout = 600

#Startup X11 apps
startup = [
    'dropbox',
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
#Debugging code - 80 column rule
addColRule(1, "55+45")
#Two Thunars / 2 chromium windows
addColRule(2, "50+50")
#Anything else - Golden Ratio
addColRule(".*", "62+38")

#=== TAGGING RULES ===
#For Skype to be at 0 :)
addTagRule("Skype", 0)
#For separate steam big-picture tag
addTagRule("Steam", "Steam")
#VLC
addTagRule("vlc", "sel+0")
#PopcornTime
addTagRule("Popcorn-Time", 0)
#Mesages from devmon
addTagRule("Zenity", "Garbage")

#=== PRE-STATUSBAR ===
#Pulseaudio sinks
text = "~/bin/mypo | awk -F '|' '!/Active/ {print \" \"$2\" \"}; /Active/ {print \" [\"$2\"] \"}'"
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
check = "top -bn1 | awk '/Mem/ {print $4}' | awk -F '/' '{print $1}'"
text = check
lower = 50
mid = 80
addBlock()
#Space at /
check = "df -h / | awk '/\// {print substr($5, 0, length($5) - 1)}'"
text = "echo `" + check + "` /"
lower = 55
mid = 80
addBlock()
#Space at /home
check = "df -h /home | awk '/home/ {print substr($5, 0, length($5) - 1)}'"
text = "echo `" + check + "` H"
lower = 55
mid = 80
addBlock()
#Space at /mnt/cloud
check = "df -h /mnt/cloud | awk '/cloud/ {print substr($5, 0, length($5) - 1)}'"
text = "echo `" + check + "` C"
lower = 55
mid = 75
addBlock()
#Space at /mnt/backup
check = "df -h /mnt/backup | awk '/backup/ {print substr($5, 0, length($5) - 1)}'"
text = "echo `" + check + "` B"
lower = 55
mid = 75
addBlock()
#CPU Temperature
check = "awk '{printf \"%.0f\", $1/1000; exit}' /sys/class/hwmon/hwmon0/temp*_input"
text = check
lower = "awk '{printf \"%.0f\", $1/1400; exit}' /sys/class/hwmon/hwmon0/temp*_max"
mid = "awk '{printf \"%.0f\", $1/1200; exit}' /sys/class/hwmon/hwmon0/temp*_crit"
addBlock()
check = "awk '{printf \"%.0f\", $1/1000; exit}' /sys/class/hwmon/hwmon1/temp*_input"
text = check
lower = "awk '{printf \"%.0f\", $1/1400; exit}' /sys/class/hwmon/hwmon1/temp*_max"
mid = "awk '{printf \"%.0f\", $1/1200; exit}' /sys/class/hwmon/hwmon1/temp*_crit"
addBlock()
#CPU Frequency
text = "cat /proc/cpuinfo | awk '/MHz/ {printf \"%.1f \", $4/1000}'"
addBlock()
#GPU Temperature
check = "nvidia-settings -q=GPUCoreTemp | awk '/GPUCoreTemp/ {printf \"%.0f\\n\", $4; exit}'"
text = check
lower = 40
mid = 52
addBlock()
#NETSTATS
text = "~/bin/netmon"
addBlock()
#CPU Load
text = "uptime | awk -F: '{print $NF}' | tr -d ','"
check = text + " | awk '{print $2}'"
lower = 7
addBlock()
#Uptime
text = "uptime | sed 's/.*up \\([^,]*\\).*/\\1/'"
addBlock()
#Time
text = "date +%a\\ %b\\ %d\\ %I:%M:%S\\ %p"
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
