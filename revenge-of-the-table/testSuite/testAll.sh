#!/bin/bash

#  testAll.sh

me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

compile="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../compiler/rtc.sh"
run="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../compiler/rt.sh"

cd "$me"

dir=`pwd`
log="$dir/log.txt"

correct="output/correct.txt"
trial="./output/trial.txt"


dateStr=`date`
echo "Test Results from $dateStr" > "$log"

RT=".rt"

t=`ls -d */`
IFS=$'\n'

maxjob=4

for f in $t
do
	bash ./individualTest.sh $f &
done

wait

for i in `ls /tmp/RTCLogTemp*.txt`
do
	cat "$i" >> "$log"
done

rm -f /tmp/RTCLogTemp*.txt

cat "$log"
