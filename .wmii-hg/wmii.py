#!/usr/bin/env python
import os
import re
import settings
import subprocess
import threading
import time

#Mask for removing \n\t\r from bash get() function result
mask = re.compile('[\n\t\r]')

#========== REGULAR FUNCTIONS ==========

#Get result from bash command
def get(command):
    return mask.sub('', os.popen(command).read())

#Just os.system but with '&'
def run(command):
    os.system(command + ' > /dev/null 2>&1 &')

#========== SET FUNCTIONS ==========

#Set condition (Good/Middle/Bad) for a block
def setCondition(name, check, lower, bigger, mid, color):
    if check != '':
        try:
            checked = float(get(check))
        except:
            checked = 0
            pass
        if bigger != "":
            if checked > float(bigger):
                setColor(name, settings.goodColors)
            elif (mid != "") and (checked > float(mid)):
                setColor(name, settings.midColors)
            else:
                setColor(name, settings.badColors)
        else:
            if checked < float(lower):
                setColor(name, settings.goodColors)
            elif (mid != "") and (checked < float(mid)):
                setColor(name, settings.midColors)
            else:
                setColor(name, settings.badColors)
    else:
        if color != '':
            setColor(name, color)
        else:
            setColor(name, settings.goodColors)

#Set column & tagging rules
def setRules():
    run('wmiir xwrite /colrules "' + settings.colRules + '"')
    run('wmiir xwrite /rules "' + settings.tagRules + '"')

#========== BLOCK FUNCTIONS ==========

#Create block
def createBlock(name):
    run('wmiir create /rbar/' + name)

#Set block text
def setStatus(name, text):
    run('wmiir xwrite /rbar/' + name + ' label "' + text + '"')

#Set block color
def setColor(name, color):
    run('wmiir xwrite /rbar/' + name + ' colors "' + color + '"')

#Create all blocks
def makeBlocks():
    for x in settings.blocks:
        createBlock(x[1])
    #CreateTime
    createBlock("Time")
    #Create AM/PM
    createBlock("TimeZ")

#Set text&color for all blocks
def statusBlocks():
    for x in settings.blocks:
        setStatus(x[1], get(x[0]))
        if x[1] != 'Status_a9':
            setCondition(x[1], x[2], x[3], x[4], x[5], x[6])
    try:
        if get('pactl stat; echo $?') == '1':
            if get('ls -l ~/.asoundrc | awk \'{print $11}\'') == "/home/ewancoder/.asoundrc_alsa_usb":
                setColor('Status_a9', settings.badColors)
            else:
                setColor('Status_a9', settings.amColors)
        elif get('pactl stat | grep "Default Sink" | awk \'{print $3}\'') == "alsa_output.usb-05e1_USB_VoIP_Device-00-Device.analog-stereo":
            setColor('Status_a9', settings.goodColors)
        else:
            setColor('Status_a9', settings.speakerColors)
    except:
        pass


#Creates a block (name) if status != ''
def check(status, name, color):
    currentStatus = get(status)
    if currentStatus != '':
        createBlock(name)
        setColor(name, color)
        setStatus(name, currentStatus)
    else:
        run('wmiir rm /rbar/' + name)

#========== STARTUP FUNCTIONS ==========

pids = []

#Startup function
def startup():
    for command in settings.startup:
        pids.append(subprocess.Popen(command, shell = True).pid)
    for command in settings.rawstartup:
        #run(command)
        subprocess.check_call(command.split())

def killAll():
    for pid in pids:
        run('kill ' + str(pid))

#========== LOOP FUNCTIONS ==========

def loopStatusBar():
    threading.Timer(2.0, loopStatusBar).start()
    statusBlocks()
    #Check for cp (cv) running and show percentage
    check('cv | grep % | awk \'{for(i=1;i<=NF;i++) if ($i ~/%$/) {print $i+0} {print " "}}\'', 'Processing', settings.midColors)
    #Check for removable media mounted and show them
    check('ls -1 /media | tr "\\n" " "', 'Devices', settings.deviceColors)
    check('if ! [ "$(ps aux | grep "devmon --unmount" | grep -v grep)" == "" ]; then echo "Unmounting..."; fi', 'DevicesUnmount', settings.deviceColors)
    #Check for git repos unstaged/unpushed/uncommited and show them
    check('~/bin/gitch | xargs -L 1 basename | tr "\\n" " "', 'AGitCheck', settings.gitColors)
    check('~/bin/gitch blue | xargs -L 1 basename | tr "\\n" " "', 'AGitCheckBlue', settings.gitBlueColors)
    #Check for pulseaudio sinks/sources and show them
    run("~/.wmii-hg/mypo")

def loopTime():
    threading.Timer(1.0, loopTime).start()
    if os.system('wmiir ls / > /dev/null 2>&1') != 0:
        killAll()
        print('Exiting wmii, bye and good luck!')
        os._exit(1)
    setColor("Time", settings.goodColors)
    if time.strftime('%p') == 'PM':
        setColor("TimeZ", settings.pmColors)
    else:
        setColor("TimeZ", settings.amColors)
    setStatus("Time", get(settings.time))
    setStatus("TimeZ", time.strftime('%p'))

def loopBackground():
    threading.Timer(settings.timeout, loopBackground).start()
    run('feh --bg-fill --randomize --recursive ' + settings.background)

def loopSysUpdate():
    threading.Timer(settings.updatesTimeout, loopSysUpdate).start()
    upd = get('yaourt -Qua')
    num = get('yaourt -Qua | wc -l')
    if num != '0':
        run('yaourt -Qua > /tmp/yaourt.updates && notify-send -u low "Updates available (' + num + ')" "$(cat /tmp/yaourt.updates)"')

def main():
    #Before all of this - we need to set background instead of ugly gray color
    loopBackground()
    #Set position
    run("wmiir xwrite /ctl bar on " + settings.position)
    #Run tray
    run("witray")
    #Make uname to noticebar
    setColor("\!notice", settings.altColors)
    run("wmiir xwrite /rbar/\!notice label $(uname -r)")
    #Handle Time
    loopTime()
    #Handle Rules
    setRules()
    #Handle StatusBar
    makeBlocks()
    loopStatusBar()
    #Update system check
    loopSysUpdate()
    #After all, Startup
    startup()

if __name__ == "__main__":
    main()
