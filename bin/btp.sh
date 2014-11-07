#!/bin/bash
for i in *.jpg; do
    temp=`echo $i | sed "s/$1/$2/g"`
    mv $i $temp
done
