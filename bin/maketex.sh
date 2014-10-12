#!/usr/bin/env bash
filename=snip.snippets

for (( i = 1; i < 10; i++ )); do
    echo -e "\n\n" >> $filename
    for (( j = 1; j < 10; j++ )); do
        echo -e "\nsnippet tab${j}$i longtable ${j}x$i" >> $filename

        temp=`echo -e "\t"`'\begin{longtable}[c]{${1:'
        for (( k = 1; k <= $j; k++ )); do
            temp="${temp}|c"
        done
        temp="${temp}|}}"
        echo "$temp" >> $filename

        temp=`echo -e "\t\t"`'\caption{${2}}'
        temp="$temp"`echo -e "\n\t\t"`'\label{${3}}\\'
        temp="$temp"`echo -e "\n\t\t"`'\hline'
        echo "$temp" >> $filename
        
        temp=`echo -e "\t\t"`'\textbf{${4:}}'
        for (( k = 2; k <= $j; k++ )); do
            int=`expr $k + 3`
            temp="$temp"' & \textbf{${'"$int"':}}'
        done
        temp="$temp"'\\'
        echo "$temp" >> $filename

        temp=`echo -e "\t\t"`'\hline'
        temp="$temp"`echo -e "\n\t\t"`'\endfirsthead'
        temp="$temp"`echo -e "\n\t\t"`'\hline'
        echo "$temp" >> $filename

        temp=`echo -e "\t\t"`'\textbf{$4}}'
        for (( k = 2; k <= $j; k++ )); do
            int=`expr $k + 3`
            temp="$temp"' & \textbf{$'"$int"'}'
        done
        temp="$temp"'\\'
        echo "$temp" >> $filename

        temp=`echo -e "\t\t"`'\hline'
        temp="$temp"`echo -e "\n\t\t"`'\endhead'
        echo "$temp" >> $filename

        for (( k = 1; k <= $i; k++ )); do
            int=`expr $int + 1`
            temp=`echo -e "\t\t\t"`'${'"$int"'}'
            for (( m = 2; m < $j; m++ )); do
                int=`expr $int + 1`
                temp="$temp"' & ${'"$int"'}'
            done
            temp="$temp"'\\'
            echo "$temp" >> $filename
        done

        temp=`echo -e "\t"`'\end{longtable}'
        temp="$temp"`echo -e "\n\t"`'${0}'
        echo "$temp" >> $filename
    done
done
