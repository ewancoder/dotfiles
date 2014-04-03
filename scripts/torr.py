#!/usr/bin/env python

from tpb import TPB
from tpb import CATEGORIES, ORDERS
import shutil

t = TPB('https://thepiratebay.se')
datafile = open("/mnt/cloud/Dropbox/Own/Serials.txt","r")
newfile = open("/tmp/newdata.txt","w")

def getsearch():
    search = t.search(fullname).order(ORDERS.SEEDERS.ASC).page(1)
    for torrent in search:
        url.append(torrent.magnet_link)
        title.append(torrent.title)

def ask():
    ans = input("-> Get it? (y,n): ")

#Main program
ans = ""
for aline in datafile:
    url = []
    title = []
    values = aline.split()

    name = values[0]
    season = values[1]
    episode = values[2]
    fullname = name + " S" + season + "E" + episode
    print(fullname)
    
    getsearch()
    nepisode = episode
    nseason = season

    if (len(url) > 0):
        print("Found "+title[0]+" !\n")
        ask()
        if ans == "y":
            new_episode = int(episode) + 1
            if (len(str(new_episode)) > 1):
                nepisode = str(new_episode)
            else:
                nepisode = "0" + str(new_episode)
    else:
        new_season = int(season) + 1
        if (len(str(new_season)) > 1):
            n_season = str(new_season)
        else:
            n_season = "0" + str(new_season)
        n_episode = "01"

        #Try again with updated season
        fullname = name + " S" + n_season + "E" + n_episode
        print(fullname)

        getsearch()

        if (len(url) > 0):
            print("Found "+title[0]+" !\n")
            ask()
            if ans == "y":
                nepisode = "02"
                nseason = n_season
        else:
            url.append("None")
            title.append("None")
            print("Not released yet.\n")

    filename = "/home/ewancoder/Downloads/Chrome Downloads/" + title[0] + ".magnet"
    with open(filename, "wt") as out_file:
        out_file.write(url[0])

    newfile.write(name + " " + nseason + " " + nepisode + "\n")

#Close files finally
datafile.close()
newfile.close()

shutil.move("/tmp/newdata.txt","/home/ewancoder/Dropbox/Own/Serials.txt")
