/*
 *  blockallocator.h
 *  FIX Parser
 *
 *  Created by Jared Pochtar on 3/19/10.
 *  Copyright 2010 Jared's Software Company. All rights reserved.
 *
 */

template <class T>
class bulkallocator {
protected:
	unsigned int unitsize;
	struct block {
		unsigned int _size;
		struct block *_next;
		T *contents;

		block(unsigned int size) : _next(0), _size(size), contents(new T[size]){}
		~block(){
			delete [] contents;
			if (_next) delete _next;
		}
	} _contents, *_last;
	unsigned int index, length;
	
public:	
	bulkallocator(unsigned int initalsize, unsigned int size = 0) : _contents(initalsize){
		index = 0;
		length = 0;
		_last = &_contents;
		unitsize = (size != 0 ? size : initalsize);			
	}
	
	inline T *alloc(){
		if (index >= _last->_size) {
			_last->_next = new struct block(unitsize);
			_last = _last->_next;
			index = 0;
		}
		length++;
		return &_last->contents[index++];
	}
	
	inline void insert(T value){
		*alloc() = value;
	}
};

template <class T>
class ptrallocator : public bulkallocator<T *> {
public:
	ptrallocator(unsigned int initalsize, unsigned int size = 0) : bulkallocator<T *>::bulkallocator(initalsize, size){}
	~ptrallocator(){
		struct bulkallocator<T*>::block *block = &this->_contents;
		int length = this->length;
		while (length > 0) {
			for (int i = 0; i < block->_size && length > 0; i++){
				delete block->contents[i];
				length--;
			}
			block = block->_next;
		}
	}
};
