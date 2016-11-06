#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>

int n = 1e9;
double result;
#define TOTAL 10

void *calculateMul( void *arg ){	
	long long i;
	long long id = *(int *) arg;
	double partial = 0;	
	for(i = (n/TOTAL)*id; i < (n/TOTAL)*(id+1); i++){
		partial += pow(-1,i)* 4.0/((i*2)+1);		
	}
	result += partial;
	return 0;
}


int main(int argc, char *argv[]){		
	THREADS = atoi(argv[1]);
	N = atoi(argv[2]);
	
	pthread_t hThread[TOTAL];
	int a[TOTAL], i;
	result = 0;
	for (int i = 0; i < TOTAL; ++i) a[i] = i;		
	for (i =0; i < 10;i++) pthread_create(&hThread[i], NULL, calculateMul, (void *)&a[i]);
	for (i =0; i < 10;i++) pthread_join(hThread[i], NULL);
	printf("%f\n",result);
	return 0;

}