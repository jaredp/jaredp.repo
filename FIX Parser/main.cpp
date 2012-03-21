#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "Datatable.h"

int main (int argc, const char * argv[]) {
	
	if (argc != 3) return 1;
	char delim = atoi(argv[2]);	
	
	FILE *in = fopen(argv[1], "r");
	if (in == NULL) return 2;
	
	fseek(in , 0 , SEEK_END);
	size_t len = ftell(in) - 1;
	rewind(in);
	
	char *contents = (char *)malloc(sizeof(char) * len);
	if (contents == NULL) return 3;
	
	size_t size = fread(contents, 1, len, in);
	if (size != len) return 2;
	fclose(in);
		
//#define DEBUG
#ifdef DEBUG
	datatable data;
	printf("%d\n", data.parse(contents, len, delim));
#else
	for (int j = 0; j < 10; j++) {
		datatable data;
		double time = omp_get_wtime();
		
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		data.parse(contents, len, delim);
		
		time = omp_get_wtime() - time;
		printf("%fMB/sec\n", len*10 / time / (1024 * 1024));	
	}
		
#endif
	
	return 0;
}