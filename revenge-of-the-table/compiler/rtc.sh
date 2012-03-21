#!/bin/bash


compDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../code/build"

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

frameworkDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../javaFramework"


RT=".rt"

filename=$(basename "$1")
outputName=${filename%$RT}

echo "Compiling $filename"

if [ -z $2 ] || [[ -n $2 && "$2" != "debug" && -z $3 ]]
	then
		"$compDir/rtc" -mainclass "$outputName" < "$1" > /tmp/"${outputName}".java
		if [ -s "/tmp/$outputName.java" ]
			then
					if [ -z $2 ] 
						then 
						 javac -d . -classpath "$frameworkDir" /tmp/"$outputName".java
					else
						javac -d "$2" -classpath "$frameworkDir" /tmp/"$outputName".java
					fi
		else
			echo "$filename did not compile"
		fi
	else
		if [ -z $3 ] 
			then
				"$compDir"/rtc -mainclass "$outputName"  < "$1" > "${outputName}".java
				if [ -s "$outputName".java ]
					then 
					javac -d . -classpath "$frameworkDir" "$outputName".java

				else
					echo "$filename did not compile"
				fi
			else
				"$compDir"/rtc -mainclass "$outputName" < "$1" > "$2${outputName}".java
				if [ -s "$2$outputName.java" ]
					then
					javac -d  "$2" -classpath "$frameworkDir" "$2$outputName".java
				else
				echo "$filename did not compile"	
				fi
			fi
fi
	
	