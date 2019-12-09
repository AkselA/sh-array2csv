#!/bin/bash

usage () {
  cat <<HELP_USAGE

  array2csv writes a bash array to a csv/tsv... file

  Usage: . array2csv -a [ array[@] ] -n [ int ] 

  Required
  -a arr[@]  An array to be exported as csv table
  -n int     Number of columns in the new table

  Optional
  -o char    Output filename (def: "arrfile.csv")
  -s char    Seperator characters (def: ",")
  
  Flags
  -c         Fill the table by column
  -p         Print the first four rows to the console
  -f         Force execution, even if existing variables might be overwritten
  -h         Display this help message

  The script needs to be sourced to work properly, on account of arrays not 
  being not possible to reference by name. This is done by prepending the call
  with a "." or the bash command "source". 

  Examples
  arr1=("Filename" "Codec" "Sample format" "Sample rate" "02 New Feelings.m4a"
        "aac" "fltp" "44100" "01 Runny Mascara.m4a" "aac" "fltp" "44100")

  . array2csv -a arr1[@] -n 4 -q -p -o "a.txt" -s "; "

  arr2=("col1" "r1c1" "r2c1" "r3c1" "r4c1" "r5c1"
        "col2" "r1c2" "r2c2" "r3c2" "r4c2" "r5c2" 
        "col3" "r1c3" "r2c3" "r3c3" "r4c3" "r5c3" 
        "col4" "r1c4" "r2c4" "r3c4" "r4c4" "r5c4"
        "col5" "r1c5" "r2c5" "r3c5" "r4c5" "r5c5"
        "col6" "r1c6" "r2c6" "r3c6" "r4c6" "r5c6")

  . array2csv -a arr2[@] -n 6 -c -p

  # This will trigger a warning, due to lexical conflict in variables
  array2csv_i="some value"

  . array2csv -a arr2[@] -n 6 -c

HELP_USAGE
return 0
}

if [[ " $*" == *-h* ]]
then
    usage
else

    [[ $_ != $0 ]] || { printf "%s\n" "ERROR: Script needs to be sourced to work properly" && return 1; }
    
    if [[ " $*" != *-f* ]]
    then
        if [[ ! -z $( ( set -o posix ; set ) | grep ^array2csv_ ) ]]
        then
            printf "  %s\n" "Warning:" "This script might be overwriting existing variables if they" \
                          "start with the pattern 'array2csv_', of which these were found:" "" \
                          "$( ( set -o posix ; set ) | grep ^array2csv_ | cut -d'=' -f1 )" "" \
                          "As such execution has been aborted. If you want to run the script" \
                          "regardless, rerun with the '-f' flag added."
            return 1
        fi
    fi

    array2csv_params=" $*"
    
    while [ "$#" -gt 1 ]
    do
        array2csv_key="$1"
        
        # Read in space delimited arguments
        case $array2csv_key in
            -a|--array)
            array2csv_arr=("${!2}")
            shift
            ;;
            -n|--ncols)
            array2csv_ncol="$2"
            shift
            ;;
            -o|--output-file)
            array2csv_ofile="$2"
            shift
            ;;
            -s|--seperator)
            array2csv_sep="$2"
            shift
            ;;
        esac
        shift
    done
    
    if [ -z ${array2csv_arr} ]
      then
        printf "%s\n" "Error:" "Need an input array"
        return 1
    fi

    if [ -z ${array2csv_ncol} ]
      then
        printf "%s\n" "Error:" "Need to specify number of columns"
        return 1
    fi

    if [ -z ${array2csv_ofile} ]
      then
        array2csv_ofile="arrfile.csv"
    fi
    
    if [ -z ${array2csv_sep} ]
      then
        array2csv_sep=","
    fi
    
    array2csv_ncolm1=$(($array2csv_ncol - 1))
    
    # If by column
    if [[ "$array2csv_params" == *-c* ]]
    then
        array2csv_nrow=$(( ${#array2csv_arr[@]} / $array2csv_ncol ))
            
        # Rearrange array
        array2csv_arr0=()
        for array2csv_i in "${!array2csv_arr[@]}"
        do
        	array2csv_j=$(( ($array2csv_i % $array2csv_ncol) * $array2csv_nrow + ($array2csv_i / $array2csv_ncol) ))
            array2csv_arr0+=( "${array2csv_arr[$array2csv_j]}" )
        done
        
        unset array2csv_arr
        array2csv_arr=("${array2csv_arr0[@]}")
        unset array2csv_arr0
    fi
    
    if [[ "$array2csv_params" == *-q* ]]
    then
        for array2csv_i in "${!array2csv_arr[@]}"
        do
            if [[ $(($array2csv_i % $array2csv_ncol)) -eq  $array2csv_ncolm1 ]]
            then
                printf "%s\n" "\"${array2csv_arr[$array2csv_i]}\""
            else
                printf "%s$array2csv_sep" "\"${array2csv_arr[$array2csv_i]}\""
            fi
        done > "$array2csv_ofile"
    else
        for array2csv_i in "${!array2csv_arr[@]}"
        do
            if [[ $(($array2csv_i % $array2csv_ncol)) -eq  $array2csv_ncolm1 ]]
            then
                printf "%s\n" "${array2csv_arr[$array2csv_i]}"
            else
                printf "%s$array2csv_sep" "${array2csv_arr[$array2csv_i]}"
            fi
        done > "$array2csv_ofile"
    fi
        
    if [[ "$array2csv_params" == *-p* ]]
    then
        printf "%s\n" "head -n 4 \"$array2csv_ofile\""
        head -n 4 "$array2csv_ofile"
    else
        printf "%s\n" "'${array2csv_ofile}' written to disk"
    fi

    unset array2csv_arr
    unset array2csv_i
    unset array2csv_j
    unset array2csv_ncol
    unset array2csv_ncolm1
    unset array2csv_nrow
    unset array2csv_ofile
    unset array2csv_params
    unset array2csv_sep
    unset array2csv_key
fi


