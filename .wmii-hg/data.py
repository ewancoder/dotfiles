#!/usr/bin/env python
block = []
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
