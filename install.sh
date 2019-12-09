#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

chmod a+x "array2csv.sh"

if cp "array2csv.sh" "/usr/local/bin/array2csv"
then
    if . array2csv -h
    then
        printf "%s\n" "Successfully installed '/usr/local/bin/array2csv'"
    else
        printf "%s\n" "Error trying to run 'array2csv -h'"
    fi
else
    printf "%s\n" "Failure" \
           "Error copying file, try running install script as sudo"
    exit 1
    sleep 8
fi

sleep 2
