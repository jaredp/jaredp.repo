#!/bin/bash

fileDir=`pwd`/`dirname $1`

cPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../javaFramework/:$fileDir"

class=".class"

filename=`basename $1`

call="${filename%$class}"
for((i = 2; i <= $#; i++))
do
	call=$call" ${!i}"
done
java -classpath "$cPath" $call

