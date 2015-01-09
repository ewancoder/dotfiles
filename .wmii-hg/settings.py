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
    else:
        name = 'Status_b' + str(x) #This is it, noone needs 20+ statusbars
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
#Color of (not)focused tag/window
normColors = '#ada #000 #000'
focusColors = '#ada #350 #000'
tagFocusColors = '#fc5 #730 #000'
#Good, Mid & Bad colors for checking state and drawing status
goodColors = '#ada #350 #000'
midColors = '#dda #640 #000'
badColors = '#daa #600 #000'
#Color for mounted devices
deviceColors = '#ada #b42 #000'
#Color for unstaged/unpushed/uncommited git repos
gitColors = '#f63 #000 #000'
gitBlueColors = '#36f #000 #000'
#Alternative color - for noticebar and volume
alternativeColors = '#aad #000 #000'
#WARNING
warnColors = '#fff #c22 #fff'
soundEffects = True
#AM/PM
amColors = '#ee8 ' + focusColors.split()[1] + ' #000'
pmColors = '#8e8 ' + focusColors.split()[1] + ' #000'

#=== GENERAL CONFIG ===
modkey = 'Mod4'
up = 'k'
down = 'j'
left = 'h'
right = 'l'

font = '-*-terminus-medium-r-*-*-12-*-*-*-*-*-*-*'
term = 'urxvt'
border = 1

#Panel position (top or bottom)
position = 'top'

#Background folder
background = '~/Dropbox/Pictures'
#Timeout to change background, in seconds
timeout = 300

#Check for Arch Linux updates each N seconds
updatesTimeout = 600

#Startup X11 apps
startup = [
    'pasystray',
    'gxkb',
    'CopyAgent',
    'dropboxd',
    'ssh -fNL 7070:127.0.0.1:7070 root@192.168.100.110',
    '~/bin/ircnotify',
    'tilda',
    'count' #as server-side for my site [bad]
]
#Startup as via bash (won't be killed upon X11 termination)
rawstartup = [
    'chromium --no-startup-window'
]

#=== COLUMN RULES ===
#For two Thunars / 2 chromium windows
addColRule(2, "50+50")
#For anything else - Golden Ratio
addColRule(".*", "62+38")

#=== TAGGING RULES ===
#For canto-curses urxvt 'Canto' window
addTagRule("Canto", 'RSS')
#For Skype to be at 0 :)
addTagRule("Skype", 0)
#For separate steam big-picture tag
addTagRule("Steam", "Steam")

#=== STATUSBAR ===
#Time
time = "date +%a\\ %b\\ %d\\ %I:%M:%S"
#Free RAM
text = "echo $(top -bn1 | grep 'Mem' | awk '{print $4}' | cut -f1 -d '/')"
check = "top -bn1 | grep 'Mem' | awk '{print $4}' | cut -f1 -d '/'"
lower = 50
mid = 80
addBlock()
#Space at /
text = "echo $(df -h / | grep / | awk '{print $5}' | sed 's/%//') '/'"
check = "df -h / | grep / | awk '{print $5}' | sed 's/%//'"
lower = 55
mid = 80
addBlock()
#Space at /home
text = "echo $(df -h /home | grep home | awk '{print $5}' | sed 's/%//') 'H'"
check = "df -h /home | grep home | awk '{print $5}' | sed 's/%//'"
lower = 55
mid = 80
addBlock()
#Space at /mnt/cloud
text = "echo $(df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//') 'C'"
check = "df -h /mnt/cloud | grep cloud | awk '{print $5}' | sed 's/%//'"
lower = 55
mid = 75
addBlock()
#Space at /mnt/backup
text = "echo $(df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//') 'B'"
check = "df -h /mnt/backup | grep backup | awk '{print $5}' | sed 's/%//'"
lower = 55
mid = 75
addBlock()
#CPU Temperature
text = "cat /sys/class/hwmon/hwmon0/device/temp1_input | cut -c1-2"
check = text
lower = 40
mid = 50
addBlock()
#CPU Frequency
text = "cat /proc/cpuinfo | grep -m 1 MHz | awk '{printf \"%.0f\\n\", $4}'"
addBlock()
#GPU Temperature
text = "nvidia-settings -q=GPUCoreTemp | grep -m 1 ewanhost | awk '{print $4}' | cut -c1-2"
check = text
lower = 40
mid = 52
addBlock()
#NETSTATS
text = "~/.wmii-hg/netmon"
color = focusColors
addBlock()
#Sound Volume
text = "if [ \"`amixer | grep 'Master'`\" == \"\" ]; then if [ \"`amixer | grep 'PCM' -A 5 | grep 'Mono: Playback' | awk {'print $5'} | cut -d '[' -f2 | cut -d '%' -f1`\" == \"\" ]; then amixer | grep 'PCM' -A 5 | grep 'Left: Playback' | awk {'print $5'} | cut -d '[' -f2 | cut -d '%' -f1; else amixer | grep 'PCM' -A 5 | grep 'Mono: Playback' | awk {'print $5'} | cut -d '[' -f2 | cut -d '%' -f1; fi; else if [ \"`amixer | grep 'Master' -A 5 | grep 'Left: Playback' | awk {'print $5'} | cut -d '[' -f2 | cut -d '%' -f1;`\" == \"\" ]; then amixer | grep 'Master' -A 5 | grep 'Mono: Playback' | awk {'print $4'} | cut -d '[' -f2 | cut -d '%' -f1; else amixer | grep 'Master' -A 5 | grep 'Left: Playback' | awk {'print $5'} | cut -d '[' -f2 | cut -d '%' -f1; fi; fi"
color = alternativeColors
addBlock()
#Current Device
text = "if [ \"`pactl stat; echo $?`\" == \"1\" ]; then if [ \"`ls -l ~/.asoundrc | awk '{print $11}'`\" == \"/home/ewancoder/.asoundrc_alsa_usb\" ]; then echo 'ALSA USB'; else echo 'ALSA Build-In'; fi; elif [ \"$(pactl stat | grep 'Default Sink' | awk '{print $3}')\" == \"alsa_output.usb-05e1_USB_VoIP_Device-00-Device.analog-stereo\" ]; then echo 'USB'; else echo 'Build-In'; fi"
color = alternativeColors
addBlock()
#CPU Uptime
text = "uptime | sed 's/.*://; s/, / /g'"
check = text + " | awk '{print $2}'"
color = focusColors
lower = 1.95
addBlock()

#Output for wmiirc
if __name__ == "__main__":
    print(modkey)
    print(up)
    print(down)
    print(left)
    print(right)

    print(normColors)
    print(focusColors)
    print(tagFocusColors)

    print(font)
    print(term)

    print(warnColors)

    print(soundEffects)
