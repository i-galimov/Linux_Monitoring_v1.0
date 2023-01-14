#!/bin/bash

WHITE1="\033[107m"
RED2="\033[41m"
GREEN3="\033[42m"
BLUE4="\033[44m"
PURPLE5="\033[45m"
BLACK6="\033[40m"

WHITEBG1="\033[97m"
REDBG2="\033[31m"
GREENBG3="\033[32m"
BLUEBG4="\033[34m"
PURPLEBG5="\033[35m"
BLACKBG6="\033[30m"

function basic_info { 
	echo -e $p1$p2 HOSTNAME'       ' = $p3$p4$HOSTNAME'                        '$end
	echo -e $p1$p2 TIMEZONE'       ' = $p3$p4$(timedatectl | awk 'NR == 4' | awk '{print $3}') UTC $(date +%-:::z)'          '$end
	echo -e $p1$p2 USER'           ' = $p3$p4$(whoami)'                        '$end
	echo -e $p1$p2 OS'             ' = $p3$p4$(cat /etc/issue | awk '{print $1,$2,$3}' | tr -s '\r\n')'       '$end
	echo -e $p1$p2 DATE'           ' = $p3$p4$(date +%d' '%B' '%Y' '%T)'       '$end
	echo -e $p1$p2 UPTIME'         ' = $p3$p4$(uptime -p | awk '{print $2,$3,$4,$5}')'                   '$end
	echo -e $p1$p2 UPTIME_SEC'     ' = $p3$p4$(cat /proc/uptime | awk '{print $1}')'                        '$end
	echo -e $p1$p2 IP'             ' = $p3$p4$(ip a | awk 'NR == 3' | awk '{print $2}')'                   '$end
	echo -e $p1$p2 MASK'           ' = $p3$p4$(ifconfig | awk 'NR == 2' | awk '{print $2}')'             '$end
	echo -e $p1$p2 GATEWAY'        ' = $p3$p4$(ip route | grep default | awk '{print $3}')'                   '$end
	echo -e $p1$p2 RAM_TOTAL'      ' = $p3$p4$(free --mega | awk 'NR == 2' | awk '{printf "%.3f GB", $2 / 1000}')'                      '$end
	echo -e $p1$p2 RAM_USED'       ' = $p3$p4$(free --mega | grep Mem | awk '{printf "%.3f GB", $3 / 1000}')'                      '$end
	echo -e $p1$p2 RAM_FREE'       ' = $p3$p4$(free --mega | grep Mem | awk '{printf "%.3f GB", $4 / 1000}')'                      '$end
	echo -e $p1$p2 SPACE_ROOT'     ' = $p3$p4$(df -m | awk 'NR == 3' | awk '{printf "%.2f MB", $2}')'                     '$end
	echo -e $p1$p2 SPACE_ROOT_USED = $p3$p4$(df -m | awk 'NR == 3' | awk '{printf "%.2f MB", $3}')'                       '$end
	echo -e $p1$p2 SPACE_ROOT_FREE = $p3$p4$(df -m | awk 'NR == 3' | awk '{printf "%.2f MB", $4}')'                     '$end
}

if [[ $# -ne 4 ]]; then
	echo "Error. Invalid number of arguments."
else
	re='(^[1-6]$)'
	if ! [[ $1 =~ $re ]] && [[ $2 =~ $re ]] && [[ $3 =~ $re ]] && [[ $4 =~ $re ]]; then
		echo "Error. The arguments take a value from 1 to 6"
	else
		if [[ $1 -eq $2 || $3 -eq $4 ]]; then
			echo "Error. The font and background colors should not match."
		else
			end='\033[0m'
			case $1 in
					"1") p1=$WHITE1;;
					"2") p1=$RED2;;
					"3") p1=$GREEN3;;
					"4") p1=$BLUE4;;
					"5") p1=$PURPLE5;;
					"6") p1=$BLACK6;;
					
			esac

			case $2 in
					"1") p2=$WHITEBG1;;
					"2") p2=$REDBG2;;
					"3") p2=$GREENBG3;;
					"4") p2=$BLUEBG4;;
					"5") p2=$PURPLEBG5;;
					"6") p2=$BLACKBG6;;
					 
			esac

			case $3 in
					"1") p3=$WHITE1;;
					"2") p3=$RED2;;
					"3") p3=$GREEN3;;
					"4") p3=$BLUE4;;
					"5") p3=$PURPLE5;;
					"6") p3=$BLACK6;;
					
			esac

			case $4 in
					"1") p4=$WHITEBG1;;
					"2") p4=$REDBG2;;
					"3") p4=$GREENBG3;;
					"4") p4=$BLUEBG4;;
					"5") p4=$PURPLEBG5;;
					"6") p4=$BLACKBG6;;
			esac
			basic_info
        
        fi
    fi
fi
