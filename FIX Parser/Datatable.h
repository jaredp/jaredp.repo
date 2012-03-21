/*
 *  Datatable.h
 *  FIX Parser
 *
 *  Created by Jared Pochtar on 3/13/10.
 *  Copyright 2010 Jared's Software Company. All rights reserved.
 *
 */

#include <stdio.h>
#include "bulkallocator.h"

enum valType {
	realType,
	integerType,
	stringType
};

class base {
public:
	virtual ~base(){}
};

class datatable {
	ptrallocator<base> tables;
public:
	int parse(char * const p_, const size_t len_, unsigned char delimiter_);
	datatable() : tables(50) {}
};
