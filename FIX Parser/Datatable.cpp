/*
 *  Datatable.cpp
 *  FIX Parser
 *
 *  Created by Jared Pochtar on 3/13/10.
 *  Copyright 2010 Jared's Software Company. All rights reserved.
 *
 */

#include "Datatable.h"
#include <omp.h>
#include <cstdlib>

template <char del>
class hashtable : base {
	unsigned int size;
	struct linkedNode {
		const char *tag;
		const char *val;
		enum valType valueType;
		struct linkedNode *next;
	} **contents;
	
	bulkallocator<linkedNode> nodes;
	unsigned int _pairs;
	
public:
	unsigned int pairs(){
		return _pairs;
	}
	
	~hashtable(){
		free(contents);
	}
	
	hashtable(const char *c, char * const len, bool unaligned) : nodes((len - c)/100, 100) {
		size = (len - c) / 40;
		//approximation of the number of pairs - different than number of nodes allocated because somehow
		//it got faster on initially allocating fewer nodes, although all nodes are eventually created,
		//just later.  May be system dependant
		
		contents = (linkedNode **)calloc(size, sizeof(linkedNode *));
		
		if (unaligned && c[-1] != del) {
			while (*(c++) != del && c < len);
		}
		
		int pairs = 0;
		
	pairloop:
		while (c < len) {
			linkedNode *currentNode = nodes.alloc();
			currentNode->tag = c;
			
			int hash = 0;
			while (*c != '=') {
				if (*c != del) {
					hash = (hash << 3) + *c;
					c++;
				} else {
					c++;
					goto pairloop;
				}
			}
			
			currentNode->val = ++c;
			if (*c == '-') c++;
			if ('0' <= *c && *c <= '9')	{
				do {
					c++; 
				} while ('0' <= *c && *c <= '9');
				if (*c != '.') {
					currentNode->valueType = *c == del ? integerType : stringType;
				} else {
					do {
						c++; 
					} while ('0' <= *c && *c <= '9');
					currentNode->valueType = *c == del ? realType : stringType;
				}
			} else {
				currentNode->valueType = stringType;
			}
			while (*(c++) != del && c < len);
			currentNode->next = contents[hash % size];
			contents[hash % size] = currentNode;
			
			pairs++;
		}
		
		_pairs = pairs;
	}
};

template <char del>
inline int __parallelParse(char * const p_, const size_t len_, ptrallocator<base> *tables) {
	if (p_[len_ - 1] != del) {
		return -1;
	}
	
#define blocksize 2
	hashtable<del> *table_s[blocksize];
	
#pragma omp parallel for
	for (int stride = 0; stride < blocksize; stride++) {
		const size_t strideSize = len_ / blocksize;		
		table_s[stride] = new hashtable<del>(&p_[stride * strideSize],
										(stride == blocksize - 1) ? &p_[len_] : &p_[(stride + 1) * strideSize],
										stride != 0);
	}
	
	int pairs = 0;
	for (int stride = 0; stride < blocksize; stride++){
		pairs += table_s[stride]->pairs();
		tables->insert((base *)table_s[stride]);
	}
	return pairs;
#undef blocksize	
}

int datatable::parse(char * const p_, const size_t len_, unsigned char delimiter_) {
	switch (delimiter_) {			
#define type(delim) case delim: return __parallelParse<delim>(p_, len_, &tables);
#define sixteens(x)		\
type(0x0##x)	\
type(0x1##x)	\
type(0x2##x)	\
type(0x3##x)	\
type(0x4##x)	\
type(0x5##x)	\
type(0x6##x)	\
type(0x7##x)	\
type(0x8##x)	\
type(0x9##x)	\
type(0xA##x)	\
type(0xB##x)	\
type(0xC##x)	\
type(0xD##x)	\
type(0xE##x)	\
type(0xF##x)	
			
			sixteens(1)
			sixteens(0)
			sixteens(2)
			sixteens(3)
			sixteens(4)
			sixteens(5)
			sixteens(6)
			sixteens(7)
			sixteens(8)
			sixteens(9)
			sixteens(A)
			sixteens(B)
			sixteens(C)
			sixteens(D)
			sixteens(E)		
			sixteens(F)
	}	
}
