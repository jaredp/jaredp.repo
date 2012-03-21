#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


f=$1

mkdir "$f"
	
	svn add "$f"
	cd "$f"
	mkdir build
	mkdir output
	cd output
	echo "" > correct.txt
	cd ..
	svn add build
	svn add output
	
	cd ..

	svn commit -m "commiting $f test" "$f"

