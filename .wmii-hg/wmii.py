#!/usr/bin/env python
import os
import re
import settings
import subprocess
import threading
import time

#Variable to store created blocks names
blocknames = []

#Mask for removing \n\t\r from bash get() function result
mask = re.compile('[\n\t\r]')

#========== OS FUNCTIONS ==========

#Get result from bash command
def get(command):
    return mask.sub('', os.popen(command).read())

#Run command in background
def run(command):
    os.system(command + ' > /dev/null 2>&1 &')

#========== SET FUNCTIONS ==========

#Set condition (Good/Middle/Bad) for a block
def setCondition(name, check, lower, bigger, mid, color):
    try:
        check = float(get(check))
    except:
        check = ''
    if color == '':
        color = settings.goodColors
    if check != '':
        lbm = [0, 0, 0]
        for index, i in enumerate([lower, bigger, mid]):
            try:
                lbm[index] = float(i)
            except:
                try:
                    lbm[index] = float(get(i))
                except:
                    lbm[index] = 0
        if lbm[1] != 0:
            if check > lbm[1]:
                setColor(name, color)
            elif check > lbm[2]:
                setColor(name, settings.midColors)
            else:
                setColor(name, settings.badColors)
        else:
            if check < lbm[0]:
                setColor(name, color)
            elif check < lbm[2]:
                setColor(name, settings.midColors)
            else:
                setColor(name, settings.badColors)
    else:
        setColor(name, color)

#Set column & tagging rules
def setRules():
    run('wmiir xwrite /colrules "' + settings.colRules + '"')
    run('wmiir xwrite /rules "' + settings.tagRules + '"')

#========== BLOCK FUNCTIONS ==========

#Create block
def createBlock(name):
    if name not in blocknames:
        run('wmiir create /rbar/' + name)
        blocknames.append(name)

#Remove block
def removeBlock(name):
    if name in blocknames:
        run('wmiir rm /rbar/' + name)
        blocknames.remove(name)

#Set block text
def setStatus(name, text):
    run('wmiir xwrite /rbar/' + name + ' label "' + text + '"')

#Set block color
def setColor(name, color):
    run('wmiir xwrite /rbar/' + name + ' colors "' + color + '"')

#========== STARTUP FUNCTIONS ==========

pids = []

#Startup function
def startup():
    for command in settings.startup:
        pids.append(subprocess.Popen(command, shell = True).pid)

def killAll():
    for pid in pids:
        run('kill ' + str(pid))

#========== LOOP FUNCTIONS ==========

def loopStatusBar():
    threading.Timer(2.0, loopStatusBar).start()
    createBlock("Time")
    for x in settings.blocks:
        currentStatus = get(x[0])
        if currentStatus != '':
            createBlock(x[1])
            setStatus(x[1], get(x[0]))
            setCondition(x[1], x[2], x[3], x[4], x[5], x[6])
        else:
            removeBlock(x[1])

def loopTime():
    threading.Timer(1.0, loopTime).start()
    if os.system('wmiir ls / > /dev/null 2>&1') != 0:
        killAll()
        print('Exiting wmii, bye and good luck!')
        os._exit(1)
    setColor("Time", settings.goodColors)
    setStatus("Time", get(settings.time))

def loopBackground():
    threading.Timer(settings.bgTimeout, loopBackground).start()
    run('feh --bg-fill --randomize --recursive ' + settings.background)

def loopEvents():
    threading.Timer(settings.eventsTimeout, loopEvents).start()
    for e in settings.events:
        run(e)

def loopSysUpdate():
    threading.Timer(settings.updatesTimeout, loopSysUpdate).start()
    try:
        if os.stat("/tmp/yaourt.updates").st_size != 0:
            run('notify-send -u low "Updates available (`wc -l /tmp/yaourt.updates`)" "`cat /tmp/yaourt.updates`"')
    except:
        pass

def main():
    #Before all of this - we need to set background instead of ugly gray color
    loopBackground()
    #Set position
    run("wmiir xwrite /ctl bar on " + settings.position)
    #Set Rules
    setRules()
    #Run tray
    run("witray")
    #Handle Time
    loopTime()
    #Handle StatusBar
    loopStatusBar()
    #Loop user-based events
    loopEvents()
    #Update system check
    loopSysUpdate()
    #After all, Startup
    startup()

if __name__ == "__main__":
    main()
