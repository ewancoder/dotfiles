#!/usr/bin/env python
import os
import re
import settings as data
import shlex
import subprocess
import threading
from time import sleep

#Mask for removing \n\t\r from bash get() function result
mask = re.compile('[\n\t\r]')

#========== REGULAR FUNCTIONS ==========

#Get result from bash command
def get(command):
    return mask.sub("", os.popen(command).read())

#========== BLOCK FUNCTIONS ==========

#Create block
def createBlock(name):
    os.system('wmiir create /rbar/'+name+' &')

#Set block text
def setStatus(name, text):
    os.system('wmiir xwrite /rbar/'+name+' label "'+text+'"')

#Set block color
def setColor(name, color):
    os.system('wmiir xwrite /rbar/'+name+' colors "'+color+'"')

#Check condition
def checkCondition(name, check, lower, bigger, mid, color, midColor, badColor):
    if color == "":
        color = data.GoodColors
    if midColor == "":
        midColor = data.MidColors
    if badColor == "":
        badColor = data.BadColors
    if check != "":
        try:
            checked = float(get(check))
        except:
            checked = 0
            pass
        if bigger != "":
            if checked > float(bigger):
                setColor(name, color)
            elif (mid != "") and (checked > float(mid)):
                setColor(name, midColor)
            else:
                setColor(name, badColor)
        else:
            if checked < float(lower):
                setColor(name, color)
            elif (mid != "") and (checked < float(mid)):
                setColor(name, midColor)
            else:
                setColor(name, badColor)
    else:
        setColor(name, color)

#========== RULES FUNCTIONS ==========

#Create column & tagging rules
def makeRules():
    os.system("wmiir write /colrules <<!\n" + data.d.colRules + "!")
    os.system("wmiir write /rules <<!\n" + data.d.tagRules + "!")

def checkrss():
    if os.path.isfile('/tmp/rssitems'):
        os.system('wmiir xwrite /lbar/RSS colors "'+data.GoodColors+'"')
        os.system('rm /tmp/rssitems')

def checkcv():
    if get('cv | grep %') != '':
        status = get('cv | grep % | awk \'{for(i=1;i<=NF;i++) if ($i ~/%$/) {print $i+0} {print " "}}\'')
        if status != '':
            createBlock('Cv')
            setColor('Cv', data.MidColors)
            setStatus('Cv', status)
    else:
        os.system('wmiir rm /rbar/Cv')

#Create all blocks
def makeBlocks():
    for x in data.d.block:
        if x[2] != "":
            color = x[2]
        else:
            color = data.GoodColors
        createBlock(x[0])
    #CreateTime
    createBlock("Time")

#Set text for all blocks
def statusBlocks():
    for x in data.d.block:
        setStatus(x[0], get(x[1]))

#Check all blocks and apply color
def colorBlocks():
    for x in data.d.block:
        checkCondition(x[0], x[3], x[4], x[5], x[6], x[2], x[7], x[8])

#========== STARTUP FUNCTIONS ==========

pids = []

#Startup function
def startup():
    for command in data.startup:
        pids.append(subprocess.Popen(command, shell = True).pid)
    for command in data.rawstartup:
        os.system(command + '&')

def killAll():
    for pid in pids:
        os.system('kill ' + str(pid))

#========== EVENTS FUNCTIONS ==========

#Events handling & eventloop
def eventloop():
    os.system("./oldwmii")

#========== MAIN FUNCTION ==========

def loopStatusBar():
    threading.Timer(2.0, loopStatusBar).start()
    colorBlocks()
    statusBlocks()
    checkrss()
    checkcv()
    os.system("~/.wmii-hg/mypo &")

def loopTime():
    threading.Timer(1.0, loopTime).start()
    if os.system('wmiir ls /') != 0:
        killAll()
        os._exit(1)
    setColor("Time", data.FocusColors)
    setStatus("Time", get(data.d.time))

def loopBackground():
    threading.Timer(data.timeout, loopBackground).start()
    os.system('feh --bg-fill --randomize --recursive ' + data.background)

def loopSysUpdate():
    threading.Timer(data.updatesTimeout, loopSysUpdate).start()
    upd = get('yaourt -Qua')
    num = get('yaourt -Qua | wc -l')
    if num != '0':
        os.system('yaourt -Qua > /tmp/yaourt.updates && notify-send -u low "Updates available (' + num + ')" "$(cat /tmp/yaourt.updates)"')

def main():
    #Before all of this - we need to set background instead of ugly gray color
    loopBackground()
    #Handle Time
    loopTime()
    #Handle Rules
    makeRules()
    #Set position
    os.system("wmiir xwrite /ctl bar on " + data.position)
    #Update system check
    loopSysUpdate()
    #After handling rules, Startup
    startup()
    #Handle StatusBar
    makeBlocks()
    loopStatusBar()

if __name__ == "__main__":
    main()
