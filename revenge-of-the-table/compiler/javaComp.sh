#!/bin/bash

frameworkDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../javaFramework"

javac -d . -classpath "$frameworkDir" $1

