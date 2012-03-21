#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RT=".rt"

compile="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../compiler/rtc.sh"
run="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../compiler/rt.sh"

log="/tmp/RTCLogTempStdin.txt"

correct="output/correct.txt"
trial="./output/trial.txt"

filename="stdin.rt"
file="stdin"

echo "Testing $file" > "$log"
"$compile" "$filename" ./build/ debug 1>/dev/null 2>>"$log"
if [ -e build/"$file".class ] 
	then
	"$run" ./build/"$file".class < $correct > $trial 2>/dev/null
 	diff -s -q $trial ./$correct >> "$log"
	echo >> "$log"
else
	echo "$file did not compile" >> "$log"
	echo >> "$log"
fi