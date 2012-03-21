#!/bin/bash

# individualTest.sh

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

f=$1

RT=".rt"


compile="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../compiler/rtc.sh"
run="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../compiler/rt.sh"

log="/tmp/RTCLogTemp${f%\/}.txt"


correct="output/correct.txt"
trial="./output/trial.txt"


cd "$f"
if [ ! -e "testScript.sh" ] 
	then 
	filename=`ls *.rt`
	file=${filename%$RT}
	echo "Testing $file" > "$log"
	"$compile" "$filename" ./build/ debug 1>/dev/null 2>>"$log"
	if [ -e build/"$file".class ] 
		then
		"$run" ./build/"$file".class > $trial 2>/dev/null
	 	diff -s -q $trial ./$correct >> "$log"
		echo >> "$log"
	else
		echo "$file did not compile" >> "$log"
		echo >> "$log"
	fi
else
	./testScript.sh >> "$log"
fi
cd ..