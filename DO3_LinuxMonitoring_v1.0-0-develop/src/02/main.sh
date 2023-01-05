#!/bin/bash

function info_sys {
	my_time=$(timedatectl | awk 'NR == 4' | awk '{print $3}')
	date_for_time=$(date +%-:::z)
	echo HOSTNAME'       ' = $HOSTNAME'                     '
	echo TIMEZONE'       ' = $my_time UTC $date_for_time'          '
	echo USER'           ' = $USER'                      '
	echo OS'             ' = $(cat /etc/issue | awk '{print $1, $2, $3}')'           '
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

if (( $# != 0 )); then 
	echo "Error. Invalid number of arguments."
else
	info_sys
	read -p "Do you want to save data into file? (Y/N): " user_answer
	if [[ $user_answer = "Y" || $user_answer = "y" ]]; then
		now_date=$(date "+%d_%m_%y_%H_%M_%S")
		file_info="$now_date.status"
		info_sys >> $file_info
	echo "Your have a file $file_info with information!"
else 
		echo "Attention. You did not save the information to a file!"
	fi
fi
