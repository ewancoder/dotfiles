#!/usr/bin/env python
block, startupList = [], []
global text, color, check, lower, bigger, mid, midColor, badColor
text, color, check, lower, bigger, mid, midColor, badColor = "", "", "", "", "", "", "", ""
global colRules, tagRules
colRules, tagRules = "", ""
global time
time = ""
global events
events = ""
global modkey, up, down, left, right, normcolors, focuscolors, font, term, border
modkey, up, down, left, right, normcolors, focuscolors, font, term, border = "", "", "", "", "", "", "", "", "", ""

def gen_sh():
    global modkey, up, down, left, right, normcolors, focuscolors, font, term, border
    sh = """
#!/bin/bash
#Configure wmii - for wmii.sh
wmiiscript=wmiirc
. wmii.sh

#Configuration Variables
MODKEY=""" + modkey + """
UP=""" + up + """
DOWN=""" + down + """
LEFT=""" + left + """
RIGHT=""" + right + """
#Bars
noticetimeout=5
noticebar=/rbar/!notice

export WMII_NORMCOLORS='""" + normcolors + """'
export WMII_FOCUSCOLORS='""" + focuscolors + """'
export WMII_FONT='""" + font + """'

set -- $(echo $WMII_NORMCOLORS $WMII_FOCUSCOLORS)
export WMII_TERM='""" + term + """'

wi_runconf -s wmiirc_local
echo colors $WMII_NORMCOLORS | wmiir create $noticebar

#Event processing
wi_events <<'!'""" + gen_events() + """!
wi_events -e

#WM Configuration
wmiir write /ctl <<!
    font $WMII_FONT
    focuscolors $WMII_FOCUSCOLORS
    normcolors $WMII_NORMCOLORS
    grabmod $MODKEY
    border """ + str(border) + """
!
xsetroot -solid "$WMII_BACKGROUND" &

#Misc
progsfile="$(wmiir namespace)/.proglist"
action rssitems &
wi_proglist $PATH >$progsfile &
witray &

#Setup Tag Bar
IFS="$wi_newline"
wmiir rm $(wmiir ls -p /lbar) >/dev/null
seltag=$(wmiir read /tag/sel/ctl | sed lq)
unset IFS
wi_tags | while read tag
do
    if [ "$tag" = "$seltag" ]; then
        echo colors "$WMII_FOCUSCOLORS"
        echo label $tag
    else
        echo colors "$WMII_NORMCOLORS"
        echo label $tag
    fi | wmiir create "/lbar/$tag"
done

wi_eventloop"""
    return sh

#Standard wmii wi_events
def gen_events():
    events = """
#Events
Event CreateTag
    echo colors "$WMII_NORMCOLORS$wi_newline" label "$@" | wmiir create "/lbar/$@"
Event DestroyTag
    wmiir remove "/lbar/$@"
Event FocusTag
    wmiir xwrite "/lbar/$@" colors "$WMII_FOCUSCOLORS"
Event UnfocusTag
    wmiir xwrite "/lbar/$@" colors "$WMII_NORMCOLORS"
Event UrgentTag
    shift
    wmiir xwrite "/lbar/$@" label "*$@"
Event NotUrgentTag
    shift
    wmiir xwrite "/lbar/$@" label "$@"
Event LeftBarClick LeftBarDND
    shift
    wmiir xwrite /ctl view "$@"
Event Unresponsive
    {
        client=$1; shift
        msg="The following client is not responding. What would you like to do?$wi_newline"
	resp=$(wihack -transient $client \
	    xmessage -nearmouse -buttons Kill,Wait -print \
	    -fn "${WMII_FONT%%,*}" "$msg $(wmiir read /client/sel/label)")
	if [ "$resp" = Kill ]; then
	    wmiir xwrite /client/$client/ctl slay &
        fi
    }&
Event Notice
    wmiir xwrite $noticebar $wi_arg

    kill $xpid 2>/dev/null # Let's hope this isn't reused...
    { sleep $noticetimeout; wmiir xwrite $noticebar ' '; }&
    xpid = $!

#Menus
Menu Client-3-Close
    wmiir xwrite /client/$1/ctl kill
Menu Client-3-Kill
    wmiir xwrite /client/$1/ctl slay
Event ClientMouseDown
    wi_fnmenu Client $2 $1 &

Menu LBar-3-Delete
    tag=$1; clients=$(wmiir read "/tag/$tag/index" | awk '/[^#]/{print $2}')
    for c in $clients; do
	if [ "$tag" = "$(wmiir read /client/$c/tags)" ]
	then wmiir xwrite /client/$c/ctl kill
	else wmiir xwrite /client/$c/ctl tags -$tag
	fi
	[ "$tag" = "$(wi_seltag)" ] &&
	    wmiir xwrite /ctl view $(wi_tags | wi_nexttag)
    done
Event LeftBarMouseDown
    wi_fnmenu LBar "$@" &

#Actions
Action showkeys
    echo "$KeysHelp" | xmessage -file - -fn ${WMII_FONT%%,*}
Action quit
    wmiir xwrite /ctl quit
Action exec
    wmiir xwrite /ctl exec "$@"
Action rehash
    wi_proglist $PATH >$progsfile
Action rssitems
    while true; do
        if [ -f /tmp/rssitems ]; then
            wmiir xwrite /lbar/RSS colors "$GOODCOLORS"
            rm /tmp/rssitems
        fi
        sleep 5
    done
Action pywmii
    ~/.wmii-hg/wmii.py

#Key Bindings
KeyGroup Moving around
Key $MODKEY-$LEFT   # Select the client to the left
    wmiir xwrite /tag/sel/ctl select left
Key $MODKEY-$RIGHT  # Select the client to the right
    wmiir xwrite /tag/sel/ctl select right
Key $MODKEY-$UP     # Select the client above
    wmiir xwrite /tag/sel/ctl select up
Key $MODKEY-$DOWN   # Select the client below
    wmiir xwrite /tag/sel/ctl select down

Key $MODKEY-space   # Toggle between floating and managed layers
    wmiir xwrite /tag/sel/ctl select toggle

KeyGroup Moving through stacks
Key $MODKEY-Control-$UP    # Select the stack above
    wmiir xwrite /tag/sel/ctl select up stack
Key $MODKEY-Control-$DOWN  # Select the stack below
    wmiir xwrite /tag/sel/ctl select down stack

KeyGroup Moving clients around
Key $MODKEY-Shift-$LEFT   # Move selected client to the left
    wmiir xwrite /tag/sel/ctl send sel left
Key $MODKEY-Shift-$RIGHT  # Move selected client to the right
    wmiir xwrite /tag/sel/ctl send sel right
Key $MODKEY-Shift-$UP     # Move selected client up
    wmiir xwrite /tag/sel/ctl send sel up
Key $MODKEY-Shift-$DOWN   # Move selected client down
    wmiir xwrite /tag/sel/ctl send sel down

Key $MODKEY-Shift-space   # Toggle selected client between floating and managed layers
    wmiir xwrite /tag/sel/ctl send sel toggle

KeyGroup Client actions
Key $MODKEY-f # Toggle selected client's fullsceen state
    wmiir xwrite /client/sel/ctl Fullscreen toggle
Key Control-q # Close client
    sc=$(wmiir read /client/sel/label)
    if [ "$sc" != "tilda" ] && [ "$sc" != "canto-curses" ]; then
        wmiir xwrite /client/sel/ctl kill
    fi

#My keys configuration
Key $MODKEY-c
    chromium &
Key $MODKEY-g
    gvim &
Key $MODKEY-p
    xboomx &
Key $MODKEY-q
    #urxvt -e screen -r rtorrent
    deluge &
Key $MODKEY-w
    urxvt -e alsamixer &
Key $MODKEY-x
    amixer -q sset Master 2500+ &
    wmiir xwrite /rbar/Status_a8 label $(amixer | grep "Left: Playback" | awk {'print $5'} | cut -d "[" -f2 | cut -d "%" -f1)
Key $MODKEY-z
    amixer -q sset Master 2500- &
    wmiir xwrite /rbar/Status_a8 label $(amixer | grep "Left: Playback" | awk {'print $5'} | cut -d "[" -f2 | cut -d "%" -f1)

Key $MODKEY-i
    sed -i 's/ca(fr),ru/us,ru/g' ~/.config/gxkb.cfg && killall gxkb && gxkb &
Key $MODKEY-Shift-i
    sed -i 's/us,ru/ca(fr),ru/g' ~/.config/gxkb.cfg && killall gxkb && gxkb &

Key $MODKEY-Shift-x
    xcompmgr &
Key $MODKEY-Shift-z
    killall xcompmgr &

Key XF86Sleep
    dbss &
Key XF86WakeUp
    urxvt -e sudo yaourt -Syua --noconfirm &
Key XF86PowerOff
    if [ $cv == "" ]; then
        cv="1"
    fi
    seltag=$(wmiir read /tag/sel/ctl | sed 1q)
    if [ $seltag == "RSS" ]; then
        wmiir xwrite /ctl view $cv
    else
        cv=$seltag
        wmiir xwrite /ctl view RSS
    fi

KeyGroup Changing column modes
Key $MODKEY-d # Set column to default mode
    wmiir xwrite /tag/sel/ctl colmode sel default-max
Key $MODKEY-s # Set column to stack mode
    wmiir xwrite /tag/sel/ctl colmode sel stack-max
Key $MODKEY-m # Set column to max mode
    wmiir xwrite /tag/sel/ctl colmode sel stack+max

KeyGroup Running programs
Key $MODKEY-a      # Open wmii actions menu
    action $(wi_actions | wimenu -h "${hist}.actions" -n $histnum) &

Key $MODKEY-Return # Launch a terminal
    eval wmiir setsid $WMII_TERM &

KeyGroup Other
Key $MODKEY-Control-t # Toggle all other key bindings
    case $(wmiir read /keys | wc -l | tr -d ' \t\n') in
    0|1)
	echo -n "$Keys" | wmiir write /keys
	wmiir xwrite /ctl grabmod $MODKEY;;
    *)
	wmiir xwrite /keys $MODKEY-Control-t
	wmiir xwrite /ctl grabmod Mod3;;
    esac

KeyGroup Tag actions
Key $MODKEY-t       # Change to another tag
    wmiir xwrite /ctl view $(wi_tags | wimenu -h "${hist}.tags" -n 50) &
Key $MODKEY-Shift-t # Retag the selected client
    # Assumes left-to-right order of evaluation
    wmiir xwrite /client/$(wi_selclient)/ctl tags $(wi_tags | wimenu -h "${hist}.tags" -n 50) &
Key $MODKEY-n	    # Move to the next tag
    wmiir xwrite /ctl view $(wi_tags | wi_nexttag)
Key $MODKEY-b	    # Move to the previous tag
    wmiir xwrite /ctl view $(wi_tags | sort -r | wi_nexttag)"""
    for x in range(0, 10):
        events = events + \
"Key $MODKEY-" + str(x) + """
    wmiir xwrite /ctl view '""" + str(x) + """'
Key $MODKEY-Shift-""" + str(x) + """
    wmiir xwrite /client/sel/ctl tags '""" + str(x) + """'
"""
    return events

def addBlock():
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

def addColRule(col, rule):
    global colRules
    colRules = colRules + "/" + str(col) + "/ -> " + str(rule) + "\n"

def addTagRule(tag, forcetag):
    global tagRules
    tagRules = tagRules + "/" + str(tag) + "/ force-tags=" + str(forcetag) + "\n"

def startup(command):
    startupList.append(command)