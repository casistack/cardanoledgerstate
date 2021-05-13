#!/bin/bash

#get output of the dump we previously got from running leader logs
#and append to our adapools prom file
#prepending with adapools_ to make it easier to find in grafana
#https://crypto2099.io/adding-pool-stats-to-grafana-dashboard/
cat /full path/leaderledger.json 2>/dev/null | jq '.assignedSlots[] | del(.at)' | tr -d \"{},:[] | awk NF | sed -e 's/^[ \t]*/adapools_/' >> /fullpathtoprom/nameofprom.prom
