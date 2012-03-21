#!/bin/bash

#  testClean.sh

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


t=`ls -d */`
IFS=$'\n'

rm -f log.txt

for f in $t
do
	cd "$f"
	cd build
	rm -f *.class
	rm -f *.java
	cd ..
	cd output
	rm -f trial.txt
	cd ..
	cd ..

done

rm -f /tmp/RTCLogTemp*.txt
