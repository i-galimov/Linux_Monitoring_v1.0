# Linux Monitoring v1.0

Linux basic bash scripting and system research.

The russian version of the task can be found in the repository.

## Contents

1. [Chapter I](#chapter-i) 
2. [Chapter II](#chapter-ii) \
    2.1. [Bash](#bash) \
    2.2. [Shell](#shell)
3. [Chapter III](#chapter-iii) \
    3.1. [First effort](#part-1-first-effort)  
    3.2. [System research](#part-2-system-research)  
    3.3. [Visual output design for the system research script](#part-3-visual-output-design-for-the-system-research-script)   
    3.4. [Configuring visual output design for the system research script.](#part-4-configuring-visual-output-design-for-the-system-research-script)  
    3.5. [File system research](#part-5-file-system-research)    
4. [Chapter IV](#chapter-iv)

## Chapter I

![linux_monitoring_v1](misc/images/linux_monitoring_v1.png)

Planet Earth, USA, California, nowadays.

You have been working late, as usual, to avoid driving home through rush hour traffic.
You think there is no one else in the office but you, until you hear noises from the office next door.
You don't pay much attention to it, any colleague might have stayed late to finish his business.
Suddenly you hear a yell from that very office (your colleague obviously thought he was alone):

`-` Ugh, I am so tired of collecting system information by hand from these computers on Linux. I probably should have learned it better before applying for the job.

You quickly realise that this is your new system administrator, hired just a couple of weeks ago. At the initiative of your teammate Mike, Linux have been installed on several machines in the office.
Your sysadmin is really trying, he's just unlucky to get a job now. \
"Poor guy. -- you thought. -- I should try to help him, since I have the time!"

You go to Mike's desk and do something bad: you look in his drawer. You are lucky to find exactly what you were looking for: clippings from articles about bash and shell.

## Chapter II

### Bash

>Bash is the shell, or command language interpreter, for the GNU operating system.
>
>The name is an acronym for the ‘Bourne-Again SHell’, a pun on Stephen Bourne, the author of the direct ancestor of the current Unix shell sh, which appeared in the Seventh Edition Bell Labs Research version of Unix.
>
>Bash is largely compatible with sh and incorporates useful features from the Korn shell ksh and the C shell csh. It is intended to be a conformant implementation of the IEEE POSIX Shell and Tools portion of the IEEE POSIX specification (IEEE Standard 1003.1). It offers functional improvements over sh for both interactive and programming use.
>
>While the GNU operating system provides other shells, including a version of csh, Bash is the default shell. Like other GNU software, Bash is quite portable. It currently runs on nearly every version of Unix and a few other operating systems - independently-supported ports exist for MS-DOS, OS/2, and Windows platforms.

### Shell

>At its base, a shell is simply a macro processor that executes commands.
>
>A Unix shell is both a command interpreter and a programming language. As a command interpreter, the shell provides the user interface to the rich set of GNU utilities. Files containing commands can be created, and become commands themselves. These new commands have the same status as system commands, allowing users or groups to establish custom environments to automate their common tasks.
>
>Shells may be used interactively or non-interactively. In interactive mode, they accept input typed from the keyboard. When executing non-interactively, shells execute commands read from a file.
>
>A shell allows execution of GNU commands, both synchronously and asynchronously.
>
>While executing commands is essential, most of the power (and complexity) of shells is due to their embedded programming languages. Like any high-level language, the shell provides variables, flow control constructs, quoting, and functions.
>
>Shells offer features geared specifically for interactive use rather than to augment the programming language. These interactive features include job control, command line editing, command history and aliases.

There was a folder labeled "materials" underneath the article clippings in Mike's drawer. As you looked in it, you found several sheets describing the features of the bash scripts.

## Chapter III

- The written bash scripts must be in the src folder
- For each task you must create a folder with the following name: **0x**, where x is the task number.
- All scripts must be decomposed and split into several files
- The main script file for each task must be named **main.sh**
- All scripts should have checks for incorrect input (not all parameters specified, wrong format parameters, etc.)
- All scripts must be run on a virtual machine *Ubuntu Server 20.04 LTS*

## Part 1. First effort

Before you start helping your colleague, you decide to test your knowledge on a very simple program.

**== Task ==**

Write a bash script. The script is run with one parameter. It is a text parameter.  
The script outputs the value of the parameter.  
If the parameter is a number, the script must output an invalid input message.

**== Solution ==**
### [Task 01](https://github.com/i-galimov/Linux_Monitoring_v1.0/blob/main/src/01/main.sh) 
```
#!/bin/bash

if [[ $# == 1 ]]; then
    value=$1
    if [[ $value =~ [^0-9] ]]; then
        echo "$value"
    else
        echo "Error, invalid input."
    fi
else
    echo "Error, invalid number of arguments."
fi
```

## Part 2. System research

Now you’re sure that you’re ready to get down to the initial idea. You quickly think of the information about the system you need to output and get to work.

**== Task ==**

Write a bash script. The script should output the following information:

**HOSTNAME** = _network name_  
**TIMEZONE** = _time zone as: **America/New_York UTC -5** (time zone must be taken from the system and be correct for the current location)_  
**USER** = _current user who ran the script_  
**OS** = _type and version of operating system_  
**DATE** = _current time as: **12 May 2020 12:24:36**_  
**UPTIME** = _system uptime_  
**UPTIME_SEC** = _system uptime in seconds_  
**IP** = _ip address of the machine on any of the network interfaces  
**MASK** = _network mask of any of the network interfaces as: **xxx.xxx.xxx.xxx**_.  
**GATEWAY** = _default gateway ip_  
**RAM_TOTAL** = _main memory size in GB with an accuracy of three decimal places as: **3.125 GB**_  
**RAM_USED** = _used memory size in GB with an accuracy of three decimal places_  
**RAM_FREE** = _free memory size in GB, with an accuracy of three decimal places_  
**SPACE_ROOT** = _root partition size in MB, with an accuracy of two decimal places, as **254.25 MB**_  
**SPACE_ROOT_USED** = _size of used space of the root partition in MB, with an accuracy of two decimal places_  
**SPACE_ROOT_FREE** = _size of free space of the root partition in MB, with an accuracy of two decimal places_

After outputting the values, suggest writing the data to a file (ask the user to answer **Y/N**).  
Responses **Y** and **y** are considered positive, all others - negative.

If the user agrees, create a file in the current directory containing the information that had been outputted.
The file name must looks like: **DD_MM_YY_HH_MM_SS.status** (The time in the file name must indicate when the data was saved).

**== Solution ==**
### [Task 02](https://github.com/i-galimov/Linux_Monitoring_v1.0/blob/main/src/02/main.sh) 
```
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

if [[ $# -eq 0 ]]; then 
	basic_info
	read -p "Do you want to save data into file? (Y/N): " user_answer
	if [[ $user_answer = "Y" || $user_answer = "y" ]]; then
		now_date=$(date "+%d_%m_%y_%H_%M_%S")
		file_info="$now_date.status"
		basic_info >> $file_info
	echo "Your have a file $file_info with information!"
	else 
		echo "Attention. You did not save the information to a file!"
	fi
else
	echo "Error. Invalid number of arguments."
fi
```

## Part 3. Visual output design for the system research script

Everything is ready! But it looks so boring... We need to add more colours to this world!

**== Task ==**

Write a bash script. Use the script from [**Part 2**](#part-2-system-research) and remove the part where the data is saved to a file.  The script is run with 4 parameters. The parameters are numeric. From 1 to 6, for example:  
`script03.sh 1 3 4 5`

Colour designations: (1 - white, 2 - red, 3 - green, 4 - blue, 5 - purple, 6 - black)

**Parameter 1** is the background of the value names (HOSTNAME, TIMEZONE, USER etc.)  
**Parameter 2** is the font colour of the value names (HOSTNAME, TIMEZONE, USER etc.)  
**Parameter 3** is the background of the values (after the '=' sign)  
**Parameter 4** is the font colour of the values (after the '=' sign)

The font and background colours of one column must not match.  
If matching values are entered, there must be a message describing the problem and offering to call the script again.
After the message output, the program should exit correctly.

**== Solution ==**
### [Task 03](https://github.com/i-galimov/Linux_Monitoring_v1.0/blob/main/src/03/main.sh) 
```
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
```

## Part 4. Configuring visual output design for the system research script

Now everything looks nice! But I don't want to have to enter the colours as parameters every time... I'll have to come up with something more convenient.

**== Task ==**

Write a bash script. Use the script from [**Part 3**](#part-3-visual-output-design-for-the-system-research-script). The colour designations are similar. The script runs without parameters. The parameters are set in the configuration file before the script is running.

This is how the configuration file must look like:
```
column1_background=2
column1_font_color=4
column2_background=5
column2_font_color=1
```

If one or more parameters are not set in the configuration file, the colour must be substituted from the default colour scheme. (Choice is at the developer's discretion).


After the system information output from [**Part 3**](#part-3-visual-output-design-for-the-system-research-script), you should output the colour scheme by indenting one empty line as follows:
```
Column 1 background = 2 (red)
Column 1 font color = 4 (blue)
Column 2 background = 5 (purple)
Column 2 font color = 1 (white)
```

When running the script with the default colour scheme, the output should look like this:
```
Column 1 background = default (black)
Column 1 font color = default (white)
Column 2 background = default (red)
Column 2 font color = default (blue)
```
**== Solution ==**
### [Task 04](https://github.com/i-galimov/Linux_Monitoring_v1.0/blob/main/src/04) 
```
#!/bin/bash

source ./conf.conf

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
	echo -e $p1$p2 UPTIME_SEC'     ' = $p3$p4$(cat /proc/uptime | awk '{print $1}')'                       '$end
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

function color_info {
	echo ""
	echo "Column 1 background = $column1_background ($p_num1_col)"
	echo "Column 1 font color = $column1_font_color ($p_num2_col)"
	echo "Column 2 background = $column2_background ($p_num3_col)"
	echo "Column 2 font color = $column2_font_color ($p_num4_col)"
}

if  [ $# -ne 0 ]
then
	echo "Error. Invalid number of arguments."
else
	export p_num1=$column1_background
	export p_num2=$column1_font_color
	export p_num3=$column2_background
	export p_num4=$column2_font_color
	re='(^[1-6]$)'
	if ! [[ $p_num1 =~ $re ]] && [[ $p_num2 =~ $re ]] && [[ $p_num3 =~ $re ]] && [[ $p_num4 =~ $re ]]
	then
		echo "Error. The arguments take a value from 1 to 6"
	else
		if [[ $p_num2 -eq $p_num1 || $p_num3 -eq $p_num4 ]]
		then
			echo "Error. The font and background colors should not match."
		else
		
			end='\033[0m'
			case $p_num1 in
					"1") p1=$WHITEBG1; p_num1_col='white';;
					"2") p1=$REDBG2; p_num1_col='red';;
					"3") p1=$GREENBG3; p_num1_col='green';;
					"4") p1=$BLUEBG4; p_num1_col='blue';;
					"5") p1=$PURPLEBG5; p_num1_col='purple';;
					"6") p1=$BLACKBG6; p_num1_col='black';;
					*) p1=$BLACKBG6; p_num1_col='black'; flag1="1";;
					
			esac

			case $p_num2 in
					"1") p2=$WHITE1; p_num2_col='white';;
					"2") p2=$RED2; p_num2_col='red';;
					"3") p2=$GREEN3; p_num2_col='green';;
					"4") p2=$BLUE4; p_num2_col='blue';;
					"5") p2=$PURPLE5; p_num2_col='purple';;
					"6") p2=$BLACK6; p_num2_col='black';;
					*) p2=$RED2; p_num2_col='red'; flag2="2";;
					 
			esac

			case $p_num3 in
					"1") p3=$WHITEBG1; p_num3_col='white';;
					"2") p3=$REDBG2; p_num3_col='red';;
					"3") p3=$GREENBG3; p_num3_col='green';;
					"4") p3=$BLUEBG4; p_num3_col='blue';;
					"5") p3=$PURPLEBG5; p_num3_col='purple';;
					"6") p3=$BLACKBG6; p_num3_col='black';;
					*) p3=$BLACKBG6; p_num3_col='black'; flag3="3";;
					
			esac

			case $p_num4 in
					"1") p4=$WHITE1; p_num4_col='white';;
					"2") p4=$RED2; p_num4_col='red';;
					"3") p4=$GREEN3; p_num4_col='green';;
					"4") p4=$BLUE4; p_num4_col='blue';;
					"5") p4=$PURPLE5; p_num4_col='purple';;
					"6") p4=$BLACK6; p_num4_col='black';;
					*) p2=$RED2; p_num4_col='red'; flag4="4";;
			esac

			if [[ $flag1 -eq 1 ]]; then
				echo -e "Error, column1_background take a value from 1 to 6. In the case error we use default value equel 6!\n" 
				column1_background="default"
			fi
			if [[ $flag2 -eq 2 ]]; then
				echo -e "Error, column1_font_color take a value from 1 to 6. In the case error we use default value equel 6!\n"
				column1_font_color="default"
			fi
			if [[ $flag3 -eq 3 ]]; then
				echo -e "Error, column2_background take a value from 1 to 6. In the case error we use default value equel 6!\n"
				column2_background="default"
			fi
			if [[ $flag4 -eq 4 ]]; then
				echo -e "Error, column2_font_color take a value from 1 to 6. In the case error we use default value equel 6!\n"
				column2_font_color="default"
			fi
			basic_info
			color_info 

			fi
		fi
	fi
```

## Part 5. File system research

Now that the system information output is prepared, looks nice and is convenient, you can get down to the second part of the plan.

**== Task ==**

Write a bash script. The script is run with a single parameter.  
The parameter is an absolute or relative path to a directory. The parameter must end with '/', for example:  
`script05.sh /var/log/`

The script must output the following information about the directory specified in the parameter:
- Total number of folders, including subfolders
- Top 5 folders with largest size in descending order (path and size)
- Total number of files
- Number of configuration files (with .conf extension), text files, executable files, log files (files with .log extension), archives, symbolic links
- Top 10 files with largest size in descending order (path, size and type)
- Top 10 executable files with largest size in descending order (path, size and hash)
- Execution time of the script

The script should output the following information:

```
Total number of folders (including all nested ones) = 6  
TOP 5 folders of maximum size arranged in descending order (path and size):  
1 - /var/log/one/, 100 GB  
2 - /var/log/two/, 100 MB  
etc up to 5
Total number of files = 30
Number of:  
Configuration files (with the .conf extension) = 1 
Text files = 10  
Executable files = 5
Log files (with the extension .log) = 2  
Archive files = 3  
Symbolic links = 4  
TOP 10 files of maximum size arranged in descending order (path, size and type):  
1 - /var/log/one/one.exe, 10 GB, exe  
2 - /var/log/two/two.log, 10 MB, log  
etc up to 10  
TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)  
1 - /var/log/one/one.exe, 10 GB, 3abb17b66815bc7946cefe727737d295  
2 - /var/log/two/two.exe, 9 MB, 53c8fdfcbb60cf8e1a1ee90601cc8fe2  
etc up to 10  
Script execution time (in seconds) = 1.5
```
**== Solution ==**
### [Task 05](https://github.com/i-galimov/Linux_Monitoring_v1.0/blob/main/src/05/main.sh) 
```
#!/bin/bash

start=`date +%s`

function count_folders {
	echo "Total number of folders (including all nested ones) = $(find $1 -type d| wc -l)"
	echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
	du -h $1 2>/dev/null | sort -hr | head -5 | awk 'BEGIN{i=1}{printf "%d - %s, %s\n", i, $2, $1; i++}'
}

function count_files {
	echo "Total number of files = $(ls -laR $1 2>/dev/null | grep ^- | wc -l)"
	echo "Number of:"
	echo "Configuration files (with the .conf extension) = $(find $1 2>/dev/null -type f -name "*.conf" | wc -l | awk '{print $1}')"
	echo "Text files = $(find $1 2>/dev/null -type f -name "*.txt" | wc -l | awk '{print $1}')"
	echo "Executable files = $(find $1 2>/dev/null -type f -executable | wc -l | awk '{print $1}')"
	echo "Log files (with the extension .log) = $(find $1 2>/dev/null -type f -name "*.log" | wc -l | awk '{print $1}')"
	echo "Archive files = $(find $1 2>/dev/null -type f -name "*.zip" -o -name "*.7z" -o -name "*.rar" -o -name "*.tar" | wc -l | awk '{print $1}')"
	echo "Symbolic links = $(find $1 2>/dev/null -type l | wc -l | awk '{print $1}')"
	echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
	for num in {1..10}
	do
		file_line=$(find $1 2>/dev/null -type f -exec du -h {} + | sort -rh | head -10 | sed "${num}q;d")
		if ! [[ -z $file_line ]]; then
			echo -n "$num - "
			echo -n "$(echo $file_line | awk '{print $2}'), "
			echo -n "$(echo $file_line | awk '{print $1}'), "
			echo "$(echo $file_line | grep -m 1 -o -E "\.[^/.]+$" | awk -F . '{print $2}')"
		fi
	done
}

function ten_exec_files {
	echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
	for num in {1..10}
	do
		file_line=$(find $1 2>/dev/null -type f -executable -exec du -h {} + | sort -rh | head -10 | sed "${num}q;d")
		if ! [[ -z $file_line ]]; then
			echo -n "$num - "
			echo -n "$(echo $file_line | awk '{print $2}'), "
			echo -n "$(echo $file_line | awk '{print $1}'), "
			path=$(echo $file_line | awk '{print $2}')
			MD5=$(md5sum $path | awk '{print $1}')
			echo "$MD5"
		fi
	done
}

function count_time {
	end=`date +%s`
	echo "Script execution time (in seconds) = $(($end-$1))"
}


if [[ $# == 1 ]]; then
	if [[ -d $1 ]]; then
		if [[ ${1: -1} = "/" ]]; then
			count_folders $1
			count_files $1
			ten_exec_files $1
			count_time $start
		else
			echo "Error. The '/'' character must be present at the end of the path."
		fi
	else
		echo "Error. Directory not exist."
	fi
else
	echo "Error. Invalid number of arguments."
fi
```

## Chapter IV

Well, now you've done all the work you wanted to do. You had to stay a little longer than usual, but it was worth it.
You pack up your stuff and, on your way out of the office, you looked into the room where you heard your colleague earlier.

`-` Hey, may I come in? - you knocked on the door.

`-` Yes... just a second. I didn't think there was anyone else here at this hour.

The door opened and, after a short conversation, you handed the inexperienced sysadmin a flash drive with the scripts.
You said goodbye and were about to leave when you remembered an important detail.

`-` Oh, I completely forgot to ask. What's your name?

`-` Sebastian.

💡 [Tap here](https://forms.yandex.ru/u/6357f484068ff03389ed9b96/) **to leave your feedback on the project**. Pedago Team really tries to make your educational experience better.
