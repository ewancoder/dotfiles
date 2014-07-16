#!/usr/bin/env python
import os
import re
import settings as data
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

#Startup function
def startup():
    if get("pidof dropbox") == "":
        for command in data.d.startupList:
            os.system(command + " &")

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
    os.system("~/bin/mypo.sh &")

def loopTime():
    threading.Timer(1.0, loopTime).start()
    setColor("Time", data.FocusColors)
    setStatus("Time", get(data.d.time))

def main():
    #Handle Time
    loopTime()
    #Handle Rules
    makeRules()
    #After handling rules, Startup
    startup()
    #Handle StatusBar
    makeBlocks()
    loopStatusBar()
    #EventLoop
    #eventloop()

main()
