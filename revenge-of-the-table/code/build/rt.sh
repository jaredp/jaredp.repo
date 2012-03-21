#!bin/bash

present=`pwd`

compDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

frameworkDir="../../javaFramework/build/:$present"

class=".class"

callingName=${1%$class}

java -classpath "$compDir/$frameworkDir" $callingName