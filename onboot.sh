#!/bin/bash
# Onboot Notification powered by Boxcar
#
# License: WTFPL 
# Author: necenzurat 
#
# How to: add a new crontab with the following line
# @reboot /path/to/onboot.sh
#
# Config
# -------------------------
# you can find this in the Boxcar 2 app
BOXCAR_KEY=""
# available sounds: http://help.boxcar.io/knowledgebase/articles/306788-how-to-send-a-notification-to-boxcar-users
sound="clanging"
# -------------------------

# Stuff stuff into vars
# -------------------------
#public_ip=$(ifconfig | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' | sed '/127.0.0/d')
public_ip=$(curl icanhazip.com)
hostname=$(hostname)
load_averege=$(uptime | awk -F'[a-z]:' '{ print $2}')
disk_usage=$(df -h | awk '$NF=="/"{printf "%d/%dGB\n", $3,$2}')
# boxcar fails if you post the percent (%) sign, FAIL!
disk_usage_percent=$(df -k /$1 | tail -1 | awk '{print $5}' | sed 's/.$//')
flavour=$(for f in $(find /etc -type f -maxdepth 1 \( ! -wholename /etc/os-release ! -wholename /etc/lsb-release -wholename /etc/\*release -o -wholename /etc/\*version \) 2> /dev/null); do echo ${f:5:${#f}-13}; done;)
date_time=$(date +"%m-%d-%Y %k:%M %:z") 
# -------------------------

# make the request
CURL=`which curl`
$CURL	-d "user_credentials=$BOXCAR_KEY" \
		-d "notification[title]=Box UP: $hostname" \
    	-d "notification[long_message]=Server Time: $date_time<br />Flavour: $flavour<br /> IP: $public_ip<br />Load: $load_averege<br />Disk Usage: $disk_usage  ($disk_usage_percent percent)" \
    	-d "notification[sound]=$sound" \
    	-d "notification[source_name]=$hostname" \
     	https://new.boxcar.io/api/notifications