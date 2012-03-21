#!/bin/bash

frameworkDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

javac -d "$frameworkDir" -classpath "$frameworkDir" "$frameworkDir"/source/*