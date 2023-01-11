#!/bin/bash
START_TIME=$(date +%s)

alias tree="find . -print | sed -e 's;/*/;|;g;s;|; |;g'"

if ! [ $# -eq 1 ]
then echo "нужно прописать путь к папке";
else
    if ! [[ $1 == */ ]]
    then echo "в конце должен использоваться /"
    else
        way=$1;
        function hesh {
            for ((i=1; i < 11; i++))
            do
                FILENAME="$(find ${MY_PATH} -type f -name '*.exe' -exec du -sh {} + | sort -rh | head -$i | tail -1 | awk '{printf "%s", $2}')"
                if [[ -z "${FILENAME}" ]]; then
                    echo "Файлов c расширением \".exe\" нет"
                    break
                fi
                CURRENT_STR="$i - $(find ${MY_PATH} -type f -name '*.exe' -exec du -sh {} + | sort -rh | head -$i | tail -1 | awk '{printf "%s, %s", $2, $1}')"
                MD5="$(md5sum ${FILENAME} | awk '{print $1}')"
                if [[ "${CURRENT_STR#*-}" == "${PREV_STR#*-}" ]]; then
                    break
                else
                    echo "${CURRENT_STR}, ${MD5}"
                    PREV_STR=$CURRENT_STR
                fi
            done
        }
        echo "Total number of folders (including all nested ones) = $(find $1 -type d | wc -l)"
        echo "TOP 5 folders of maximum size arranged in descending order (path and size): $(du -c $way | sort -rh | sed -n '3,8'p | awk '{print NR" - " $2 "/, " $1"K"}')" # sed -n'$'p - вывод строк / NR нумерация строк
        echo "etc up to = $(find $1 -type f -exec ls -l {} \; | wc -l)"
        echo "Number of:"
        echo "Configuration files (with the .conf extension) = $(find $1 -type f -exec ls -l {} \; | grep ".conf$" | wc -l)"
        echo "Text files = $(find $1 -type f -exec ls -l {} \; | grep ".txt$" | wc -l)"
        echo "Executable files = $(find $1 -type f -perm /a=x | wc -l)"
        echo "Log files (with the extension .log) = $(find $1 -type f -exec ls -l {} \; | grep ".log$" | wc -l)"
        echo "Archive files = $(find $way -type f | grep "\.(zip|rar|gz|tar|7z)" | wc -l)"
        echo "Symbolic links = $(ls -la $1 | grep "^l" | wc -l)" #sed -n '$'p все файлы вроде
        echo "TOP 10 files of maximum size arranged in descending order (path, size and type): $(find -type f -exec ls -s {} \; | sort -hr | head -10 | awk -F. '{print NR" - "$0" "$NF}')" #NF информация сколько строк, ; $NF вывод последнего аргумента ; -F символ разделения
        echo "etc up to = $(find $1 -type f -exec du -h {} \; | sort -rh | head -10 | cat -n | awk '{print $1 " - " $3 ", " $2}')"
        echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
        hesh  # внимательнее проверить, возможно не верная реализация
    fi
fi
END_TIME=$(date +%s)
DIFF=$(( $END_TIME - $START_TIME ))
echo "Script execution time (in seconds) = $DIFF"
