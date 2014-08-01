#Goto hook, ewancoder, 2014.
#Using these hooks you can make your own RSS feed based on the links you read.

from canto_next.hooks import on_hook

import os
import shlex

#Works every time link is opened, because even fetch() uses goto()
def goto(goto, links):
    for link in links:
        os.system("echo " + shlex.quote(link) + " >> ~/.canto-ng/saved/$(date +\%b.\%d).txt")

on_hook("goto_hook", goto)
