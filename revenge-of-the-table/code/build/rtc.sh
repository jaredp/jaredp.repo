#!bin/bash


compDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

frameworkDir="../../javaFramework/build"

RT=".rt"

filename=$(basename $1)
outputName=${filename%$RT}

if [ -z $2 ] || [[ -n $2 && "$2" != "debug" && -z $3 ]]
	then
		$compDir/rtc < $1 > /tmp/${outputName}_.java
		`awk -f $compDir/nameHelper.awk -v name=$outputName  /tmp/${outputName}_.java > /tmp/$outputName.java`
		if [ -s "/tmp/$outputName.java" ]
			then
					if [ -z $2 ] 
						then 
						javac -d . -classpath "$compDir/$frameworkDir" /tmp/$outputName.java
					else
						javac -d "$2" -classpath "$compDir/$frameworkDir" /tmp/$outputName.java
					fi
		else

			echo "$filename did not compile"
		fi
	else
		if [ -z $3 ] 
			then
				$compDir/rtc < $1 > ${outputName}_.java
				`awk -f $compDir/nameHelper.awk -v name=$outputName ${outputName}_.java > $outputName.java`
				rm ${outputName}_.java
				if [ -s "$outputName.java" ]
					then 
					javac -d . -classpath "$compDir/$frameworkDir" $outputName.java

				else
					echo "$filename did not compile"
				fi
			else
				$compDir/rtc < $1 > $2${outputName}_.java
				`awk -f $compDir/nameHelper.awk -v name=$outputName  $2${outputName}_.java > /tmp/$2$outputName.java`
				rm ${outputName}_.java
				if [ -s "$2$outputName.java" ]
					then
					javac -d  "$2" -classpath "$compDir/$frameworkDir" $2$outputName.java
				else
				echo "$filename did not compile"	
				fi
			fi
fi
	
	