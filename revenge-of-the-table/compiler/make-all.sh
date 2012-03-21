#!/bin/bash

cd `dirname $0`

make -C ../AST-PP/build
make -C ../code/build

../javaFramework/build.sh

