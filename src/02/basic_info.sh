#!/bin/bash

function basic_info { 
	echo HOSTNAME'       ' = $HOSTNAME'                     '
	echo TIMEZONE'       ' = $(timedatectl | awk 'NR == 4' | awk '{print $3}') UTC $(date +%-:::z)'          '
	echo USER'           ' = $(whoami)'                      '
	echo OS'             ' = $(cat /etc/issue | awk '{print $1,$2,$3}' | tr -s '\r\n')'           '
	echo DATE'           ' = $(date +%d' '%B' '%Y' '%T)'     '
	echo UPTIME'         ' = $(uptime -p | awk '{print $2,$3,$4,$5}')'                   '
	echo UPTIME_SEC'     ' = $(cat /proc/uptime | awk '{print $1}')'                        '
	echo IP'             ' = $(ip a | awk 'NR == 3' | awk '{print $2}')'                   '	
	echo MASK'           ' = $(ifconfig | awk 'NR == 2' | awk '{print $2}')'                     '
	echo GATEWAY'        ' = $(ip route | grep default | awk '{print $3}')'                      '
	echo RAM_TOTAL'      ' = $(free --mega | awk 'NR == 2' | awk '{printf "%.3f GB", $2 / 1000}')'                      '
	echo RAM_USED'       ' = $(free --mega | grep Mem | awk '{printf "%.3f GB", $3 / 1000}')'                      '
	echo RAM_FREE'       ' = $(free --mega | grep Mem | awk '{printf "%.3f GB", $4 / 1000}')'                      '
	echo SPACE_ROOT'     ' = $(df -m | awk 'NR == 3' | awk '{printf "%.2f MB", $2}')'                    '
	echo SPACE_ROOT_USED = $(df -m | awk 'NR == 3' | awk '{printf "%.2f MB", $3}')'                    '
	echo SPACE_ROOT_FREE = $(df -m | awk 'NR == 3' | awk '{printf "%.2f MB", $4}')'                    '
}
