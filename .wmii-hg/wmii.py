#!/usr/bin/env python
import os
import re
import settings as data
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
        checked = float(get(check))
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

#Create all blocks
def startBlocks():
    for x in data.s.block:
        if x[2] != "":
            color = x[2]
        else:
            color = data.GoodColors
        createBlock(x[0])

#Set text for all blocks
def statusBlocks():
    for x in data.s.block:
        setStatus(x[0], get(x[1]))

#Check all blocks and apply color
def colorBlocks():
    for x in data.s.block:
        checkCondition(x[0], x[3], x[4], x[5], x[6], x[2], x[7], x[8])

#========== MAIN FUNCTION ==========

def main():
    startBlocks()
    while True:
        colorBlocks()
        statusBlocks()
        sleep(2)

main()
