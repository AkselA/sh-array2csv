# array2csv
#### Convert a Bash array to CSV

### Istall

1. Clone this repository
2. Run `install.sh` in a command terminal.  
This will make `array2csv.sh` executable, copy it to `/usr/local/bin/array2csv` and test it by running a couple of small examples.


### Usage

```bash
arr1=("Filename" "Codec" "Sample format" "Sample rate" 
      "02 New Feelings.m4a" "aac" "fltp" "44100"
      "01 Runny Mascara.m4a" "aac" "fltp" "44100")

# Notice that the script needs to be sourced
. array2csv -a arr1[@] -n 4 -q -p -o "a.txt" -s "; "

# For information on usage
. array2csv -h

```


