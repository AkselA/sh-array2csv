#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

chmod a+x "array2csv.sh"

if cp "array2csv.sh" "/usr/local/bin/array2csv"
then
    arr1=("File"        "Codec" "Sample format" "Sample rate" 
          "track 1.m4a" "aac"   "fltp"          "44100"
          "track 2.m4a" "aac"   "fltp"          "44100")

    if . array2csv -h && . ./array2csv.sh -a arr1[@] -n 4 -q -p -o -s "; " /tmp/test.csv
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
