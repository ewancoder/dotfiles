#!/usr/bin/env python
import os
import re
import data
from time import sleep

mask = re.compile('[\n\t\r]')

#===== WMII FUNCTIONS =====

#Get result from bash command
def get(command):
    return mask.sub("", os.popen(command).read())

#Check condition
def checkCondition(name, check, lower, bigger, mid, color, midColor, badColor):
    if color == "":
        color = data.GoodColors
    if midColor == "":
        midColor = data.MidColors
    if badColor == "":
        badColor = data.BadColors
    checked = float(get(check))
    if check != "":
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

def checkLoop():
    for x in data.block:
        if x[3] != "":
            checkCondition(x[0], x[3], x[4], x[5], x[6], x[2], x[7], x[8])

def statusLoop():
    for x in data.block:
        setStatus(x[0], get(x[1]))

#Create block
def createBlock(name, color):
    os.system('wmiir create /rbar/'+name+' &')
    setColor(name, color)

def startLoop():
    for x in data.block:
        if x[2] != "":
            color = x[2]
        else:
            color = data.GoodColors
        createBlock(x[0], color)

#Set block color
def setColor(name, color):
    os.system('wmiir xwrite /rbar/'+name+' colors "'+color+'"')

#Set block text
def setStatus(name, text):
    os.system('wmiir xwrite /rbar/'+name+' label "'+text+'"')

def main():
    startLoop()
    while True:
        checkLoop()
        statusLoop()
        sleep(2)

main()
