
#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>


//#define N 1024					// Tamaño de la matriz
//#define HILOS 10				// Cantidad de HILOS
#define MAXNUMBER 10		// Tamaño maximo de los numeros

int N;
int HILOS;
double result;
double **A, **B, **C;


void *calculateMul( void *arg ){	
	int id = *(int *) arg;
	int i, j;		
	while( id < N ){
		i = 0;
		C[id][i] = 0;
		for(i = 0; i < N; i++ ){
			for(j = 0; j < N; j++){
				C[id][i] += A[id][j] * B[j][i];
			}
			
		}
		id += HILOS ;
	}
}

int main(int argc, char *argv[]){	
	HILOS = atoi(argv[1]);
	N = atoi(argv[2]);
	
	int cantHilos = (N < HILOS) ? N : HILOS;  //'Si el N es menor que la cantidad de hilos requeridos, se lanzan N hilos, si no la cantidad de hilos inicial '
	pthread_t hThread[cantHilos];
	int numProcess[cantHilos];	

	int i,j;
	srand(time(NULL));
	
	A = malloc(sizeof(double)*N);		
	B = malloc(sizeof(double)*N);		
	C = malloc(sizeof(double)*N);		
	for(j = 0; j < N; j++){
		A[j] = malloc(sizeof(double)*N);		
		B[j] = malloc(sizeof(double)*N);		
		C[j] = malloc(sizeof(double)*N);		
	}


	for(i = 0; i < N; i++){		
		for(j = 0; j < N; j++){
			A[i][j] = rand() % MAXNUMBER;
			B[i][j] = rand() % MAXNUMBER;
			//A[i][j] = rand();
			//B[i][j] = rand();			
		}
	}	

	for(i = 0; i < cantHilos; i++){
		numProcess[i] = i;
		pthread_create(&hThread[i], NULL, calculateMul, (void *)&numProcess[i]);
	}
	
	for(i = 0; i < cantHilos; i++) 
		pthread_join(hThread[i], NULL);

	for (i = 0; i < N; i++){
	    for(j = 0; j < N; j++)
	         printf("%f     ", A[i][j]);
	    printf("\n");
	 }
	 printf("\n");
	 printf("\n");
	 for (i = 0; i < N; i++){
	    for(j = 0; j < N; j++)
	         printf("%f     ", B[i][j]);
	    printf("\n");
	 }
	 printf("\n");
	 printf("\n");
	 for (i = 0; i < N; i++){
	    for(j = 0; j < N; j++)
	         printf("%f     ", C[i][j]);
	    printf("\n");
	 }

	return 0;


	
	

}


