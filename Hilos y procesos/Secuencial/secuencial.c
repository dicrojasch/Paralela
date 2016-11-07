
#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>
#include <float.h>

//#define N 1024					// Tamaño de la matriz
//#define HILOS 10				// Cantidad de HILOS
#define MAXNUMBER DBL_MAX	// Tamaño maximo de los numeros

int N;
int HILOS;
double result;
double **A, **B, **C;


void calculateMul(){
	int i, j, id = 0;	
	
	while( id < N ){
		i = 0;
		C[id][i] = 0;
		for(i = 0; i < N; i++ ){
			for(j = 0; j < N; j++){
				C[id][i] += A[id][j] * B[j][i];
			}			
		}
		id++ ;
	}
}

int main(int argc, char *argv[]){	
	N = atoi(argv[1]);
	
	int cantHilos = (N < HILOS) ? N : HILOS;  //'Si el N es menor que la cantidad de hilos requeridos, se lanzan N hilos, si no la cantidad de hilos inicial '

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
			A[i][j] = j;
			B[i][j] = j;		
		}
	}	
	calculateMul();	

	return 0;
}


