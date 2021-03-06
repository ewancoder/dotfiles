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
statusTimeout = 5
eventsTimeout = 5
bgTimeout = 300
updatesTimeout = 600

#Startup X11 apps
startup = [
    'dropbox',
    #'ssh -fNL 7070:127.0.0.1:7070 root@`cat ~/.rpi`',
    'tilda',
    'chromium --no-startup-window'
]
#Events are executed each 5 seconds
events = [
    '~/bin/unarchive',
    '~/bin/gitch > /dev/shm/wmii.gitch',
    'df -h > /dev/shm/wmii.df'
    #'~/bin/ircnotify'
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
#For Slack to be at 0 :)
addTagRule("Slack", 0)
#For separate steam big-picture tag
addTagRule("Steam", "Steam")
#VLC
addTagRule("vlc", "sel+0")
#PopcornTime
addTagRule("Popcorn-Time", 0)
#Mesages from devmon
addTagRule("Zenity", "Garbage")
#Feed the beast
addTagRule("net-ftb-tracking-piwik-PiwikTracker", "Garbage")

#=== PRE-STATUSBAR ===
    #Pulseaudio sinks
    #text = "~/bin/mypo | nawk -F '|' '!/Active/ {print \" \"$2\" \"}; /Active/ {print \" [\"$2\"] \"}'"
    #addBlock()
#GIT activity
text = "nawk '/Unstaged/ {print $2\" \"}' /dev/shm/wmii.gitch"
color = gitColors
addBlock()
text = "nawk '/Ahead/ {print $2\" \"}' /dev/shm/wmii.gitch"
color = gitBlueColors
addBlock()
text = "nawk '/Staged/ {print $2\" \"}' /dev/shm/wmii.gitch"
color = gitGreenColors
addBlock()
#Removable USB
text = 'ls /media'
color = deviceColors
addBlock()
#USB backup
#text = 'if [ -f /tmp/usb.lock ]; then echo "Working..."; fi'
#color = deviceColors
#addBlock()
#Unmounting message
text = 'if [[ ! `ps aux | nawk \'/devmon --unmount/ && !/awk/\'` == "" ]]; then echo "Unmounting..."; fi'
color = deviceColors
addBlock()
#Check for cp/mv activity
#text = "progress | egrep -o '[0-9]+..%' | egrep -v 'grep|cut'"
#color = midColors
#addBlock()

#=== STATUSBAR ===
#Free RAM
check = "free -m | nawk '/Mem:/ {print $7}'"
text = check
bigger = 8000
mid = 3000
addBlock()
#Space at /
check = "nawk '/\/$/ {print substr($5, 0, length($5) - 1)}' /dev/shm/wmii.df"
text = "echo `" + check + "` /"
lower = 55
mid = 80
addBlock()
#Space at /home
check = "nawk '/home/ {print substr($5, 0, length($5) - 1)}' /dev/shm/wmii.df"
text = "echo `" + check + "` H"
lower = 55
mid = 80
addBlock()
#Space at /mnt/cloud
check = "nawk '/cloud/ {print substr($5, 0, length($5) - 1)}' /dev/shm/wmii.df"
text = "echo `" + check + "` C"
lower = 55
mid = 75
addBlock()
#Space at /mnt/backup
check = "nawk '/backup/ {print substr($5, 0, length($5) - 1)}' /dev/shm/wmii.df"
text = "echo `" + check + "` B"
lower = 55
mid = 75
addBlock()
#CPU Temperature
check = "nawk '{printf \"%.0f\", $1/1000; exit}' /sys/class/hwmon/hwmon0/temp*_input"
text = check
lower = "nawk '{printf \"%.0f\", $1/1400; exit}' /sys/class/hwmon/hwmon0/temp*_max"
mid = "nawk '{printf \"%.0f\", $1/1200; exit}' /sys/class/hwmon/hwmon0/temp*_crit"
addBlock()
check = "nawk '{printf \"%.0f\", $1/1000; exit}' /sys/class/hwmon/hwmon1/temp*_input"
text = check
lower = "nawk '{printf \"%.0f\", $1/1400; exit}' /sys/class/hwmon/hwmon1/temp*_max"
mid = "nawk '{printf \"%.0f\", $1/1200; exit}' /sys/class/hwmon/hwmon1/temp*_crit"
addBlock()
#CPU Frequency
text = "cat /proc/cpuinfo | nawk '/MHz/ {printf \"%.1f \", $4/1000}'"
addBlock()
#GPU Temperature
check = "nvidia-smi | nawk '/[0-9]+C/ {print $3}' | sed 's/.$//'"
text = check
lower = 40
mid = 52
addBlock()
#NETSTATS
text = "~/bin/netmon"
addBlock()
#CPU Load
text = "uptime | nawk -F: '{print $NF}' | tr -d ','"
check = text + " | nawk '{print $2}'"
lower = 7
addBlock()
#Uptime
#text = "uptime | sed 's/.*up \\([^,]*\\).*/\\1/'"
#addBlock()
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
