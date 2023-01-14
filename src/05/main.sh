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