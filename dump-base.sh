#! /bin/bash
# Skriptica za backup fajlova i baza sa vps-a
#Author: Milenko Mitrović
#
#System setup
NOW=`date +%Y-%m-%d`
KEEPDAYS=30

#Local folder for backup
loc_loc=~/backup

#Server list
cat servers.txt | cut -f1 | while read servername

do 


#Entry parameters for VPS's from servers.txt

dbname=`cat servers.txt |grep $servername | awk '{printf $2}'`
dbuser=`cat servers.txt |grep $servername | awk '{printf $3}'`
dbpass=`cat servers.txt |grep $servername | awk '{printf $4}'`
rem_loc=`cat servers.txt |grep $servername | awk '{printf $5}'`
ruser=`cat servers.txt |grep $servername | awk '{printf $6}'`

#test command not used for anything just checking readout from servers.txt
echo $servername
# If there is no directory by name of the server create it
if [ ! -d "$loc_loc/$servername" ]; then
mkdir -p "$loc_loc"/"$servername"
fi
#File where to dump base - first check is there database folder
if  [ ! -d "$loc_loc/$servername/database" ]; then
mkdir -p "$loc_loc"/"$servername/database"
fi

FILE="$loc_loc"/"$servername"/mysql$servername-$NOW.gz
#Dump MySql database to file
ssh $ruser@$servername "mysqldump -q -u $dbuser -h $servername -p $dbpass $dbname | gzip -9" > $FILE
#Copy files from server
ssh $ruser@$servername "tar cvzf -/'$rem_loc'" > $loc_loc/$servername/database/$servername_$NOW.tar.gz
#rsync -arv $ruser@$servername:$rem_loc/* $loc_loc/$servername/database/$servername_$NOW.tar.gz

done
# Version history
#------------------
# 1.0  setup basic read of parameters and dump mysql baze
# 1.1 Changed line for download and zip on the fly for the remote folder






