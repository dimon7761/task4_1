#!/bin/bash
#Dmitriy Litvin 2018
#CONFIG
outfile='task4_1.out'


#FILE
outfile=$(echo `pwd`/$outfile)
if [ -f $outfile ]; then rm $outfile; fi; touch $outfile

#HARDWARE
echo --- Hardware --- >> $outfile
data=$(cat /proc/cpuinfo | grep  "model name" | head -n 1 | cut -d ":" -f2- | sed 's/^[ \t]*//')
echo CPU: $data >> $outfile
data=$(free -m  |  awk 'NR==2{print $2}')
echo RAM: $data "MB" >> $outfile
data=$(dmidecode -s baseboard-manufacturer)
data2=$(dmidecode -s baseboard-product-name)
if [ -z "$data" ]; then data='Unknown'; fi
if [ -z "$data2" ]; then data2='Unknown'; fi
echo Motherboard: $data $data2 >> $outfile
data=$(dmidecode -s system-serial-number)
if [ -z "$data" ]; then data='Unknown'; fi
echo System Serial Number: $data >> $outfile

#SYSTEM
echo --- System ---  >> $outfile
data=$(cat /etc/*release* | grep PRETTY_NAME | cut  -d '"' -f 2)
echo OS Distribution: $data >> $outfile
data=$(uname -r)
echo Kernel version: $data >> $outfile
data=$(ls -clt / | tail -n 1 | awk '{ print $6, $7, $8 }')
echo Installation date: $data >> $outfile
data=$(hostname -f)
echo Hostname: $data >> $outfile
data=$(uptime -p |  cut -d 'p' -f 2)
echo Uptime:  $data >> $outfile
data=$(ps -ax | sed  -e '1d' | wc -l)
echo Processes running: $data >> $outfile
data=$(who | wc -l)
echo User logged in: $data >> $outfile

#NETWORK
echo --- Network --- >> $outfile
int=($(cat /proc/net/dev | awk -F : '{if (NR>2) print $1}'))
intnumb=${#int[@]}
for (( i=0; i<$intnumb; i++)); do
data=$(ip -4 a show ${int[${i}]} | grep "inet " | awk '{print $2}')
if [ -z "$data" ]; then data='-'; fi
echo ${int[${i}]}':' $data >> $outfile
done
