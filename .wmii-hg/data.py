#!/usr/bin/env python
block = []
global text, color, check, lower, bigger, mid, midColor, badColor
text, color, check, lower, bigger, mid, midColor, badColor = "", "", "", "", "", "", "", ""

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
