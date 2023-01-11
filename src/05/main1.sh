#!/bin/bash

export start=$(date +%s%N)

c_default='\e[0m'
c_white='\033[1;97m'
c_red='\033[1;91m'

function print() {
    printf "${c_white}Total number of folders (including all nested ones) ${c_red}= $TOTAL_NUM_FOLDER${c_default}\n"
    printf "${c_white}TOP 5 folders of maximum size arranged in descending order (path and size):${c_default}\n" 
    printf "$TOP_5_FOLDERS${c_default}\n"
    printf "${c_white}Total number of files ${c_red}= $TOTAL_NUM_FILE${c_default}\n"
    printf "${c_white}Number of:\n"
    printf "${c_white}Configuration files (with the .conf extension) ${c_red}= $CONFIG_FILE${c_default}\n"
    printf "${c_white}Text files ${c_red}= $TEXT${c_default}\n"  
    printf "${c_white}Executable files ${c_red}= $EXECUTABLE${c_default}\n"
    printf "${c_white}Log files (with the extension .log) ${c_red}= $LOG${c_default}\n"
    printf "${c_white}Archive files ${c_red}= $ARCHIVE\n"  
    printf "${c_white}Symbolic links ${c_red}= $SYMBOLIC\n"  
    printf "${c_white}TOP 10 files of maximum size arranged in descending order (path, size and type):${c_default}\n"
    printf "$TOP_10_FILES${c_default}\n"
    printf "${c_white}TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):${c_default}\n"
    for (( i = 0; i < 10; i++ ))
    do  
        if [[ -z "${array_count[i]}" ]]
        then
            break
        fi
            printf "${array_count[$i]} - ${array_name[$i]}, ${array_mem[$i]}, ${array_sum[$i]}${c_default}\n"
    done

    printf "${c_white}Script execution time (in seconds) ${c_red}= $secw${c_default}\n"
}

TOTAL_NUM_FOLDER=`find $1 -type d | wc -l`
TOP_5_FOLDERS=`du -h $1 | sort -rh | head -5 | cat -n | awk '{print $1 " - " $3 ", " $2}'`
TOTAL_NUM_FILE=`find $1 -type f -exec ls -l {} \; | wc -l`
CONFIG_FILE=`find $1 -type f -exec ls -l {} \; | grep ".conf$" | wc -l`
TEXT=`find $1 -type f -exec ls -l {} \; | grep ".txt$" | wc -l`
EXECUTABLE=`find $1 -type f -perm /a=x | wc -l`
LOG=`find $1 -type f -exec ls -l {} \; | grep ".log$" | wc -l`
ARCHIVE=`find $1 -type f -name "*.zip" -o -name "*.7z" -o -name "*.rar" -o -name "*.tar" | wc -l`
SYMBOLIC=`ls -la $1 | grep "^l" | wc -l`
TOP_10_FILES=`find $1 -type f -exec du -h {} \; | sort -rh | head -10 | cat -n | awk '{print $1 " - " $3 ", " $2}'`

COUNT=`find $1 -type f -perm /a=x -exec du -h {} \; | sort -rh | head -10 | cat -n | awk '{print $1}'`
NAME=`find $1 -type f -perm /a=x -exec du -h {} \; | sort -rh | head -10 | cat -n | awk '{print $3}'`
MEM=`find $1 -type f -perm /a=x -exec du -h {} \; | sort -rh | head -10 | cat -n | awk '{print $2}'`
SUM=`find $1 -type f -exec md5sum {} \; | sort -rh | head -10 | awk '{print $1}'`

array_count=($COUNT)
array_name=($NAME)
array_mem=($MEM)
array_sum=($SUM)
end=$(date +%s%N)
sec=$(($end - $start))
secw=`echo "scale=3; $sec / 1000000000"| bc`

print