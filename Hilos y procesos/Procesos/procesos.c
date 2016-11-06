#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>

#define MAXNUMBER 10

int PROCESS, N;
double **A, **B;

double *calculateMul( int id ){
	// printf("Num %d \n", id);		
	int i, j;
	double *C;
	C = malloc(sizeof(double)*N);
	while( id < N ){
		i = 0;
		C[i] = 0;
		for(i = 0; i < N; i++ ){
			for(j = 0; j < N; j++){
				C[i] += A[id][j] * B[j][i];
				
			}	
			// printf("%f, ",C[i] );		
			
		}
		// printf("\n");
		id += PROCESS ;
	}
	return C;
}



int main(int argc, char *argv[]){		
	PROCESS = atoi(argv[1]);
	N = atoi(argv[2]);	

	int cantProcess = (N < PROCESS) ? N : PROCESS; 

	pid_t pid[cantProcess];
	int pipefd[cantProcess][2];
	
	int numProcess, r;	

	int i,j;
	srand(time(NULL));
	
	A = malloc(sizeof(double)*N);		
	B = malloc(sizeof(double)*N);			
	for(j = 0; j < N; j++){
		A[j] = malloc(sizeof(double)*N);		
		B[j] = malloc(sizeof(double)*N);					
	}	


	for(i = 0; i < N; i++){		
		for(j = 0; j < N; j++){
			// A[i][j] = rand() % MAXNUMBER;
			// B[i][j] = rand() % MAXNUMBER;
			A[i][j] = j;
			B[i][j] = j;
			printf("%f ",A[i][j] );
			// A[i][j] = rand();
			//B[i][j] = rand();			
			

		}
		printf("\n");
	}
	printf("\n");

	for( i = 0; i < cantProcess; i++){
		r = pipe(pipefd[i]);
		if( r < 0 ){
			perror("Error en la funcion pipe:\n");
			continue;
		}
		pid[i] = fork();			
		if( pid[i] < 0 ) {	// si entra aquí hay una nueva conexión pero no sera posible dejar el servidor en espera
			perror("\n-->Error en fork(): Error al dejar el servidor en espera para recibir una nueva conexión.");
			break;
		}
		if( pid[i]  == 0) {	
			numProcess = i; 					
			break;	
		}
		else close(pipefd[i][1]); // Se cierra el de escritura (0 lectura - 1 escritura)
	}

	if( pid[numProcess] == 0 ){
		close(pipefd[numProcess][0]);
		double *C;
		C = malloc(sizeof(double)*N);		
		C = calculateMul(numProcess);		
		// for(i = 0; i < N; i++){
		// 	printf("%f ", C[i] );
		// }
		// printf("\n");
		write(pipefd[numProcess][1], C, sizeof(double)*N);
		close(pipefd[numProcess][1]);

	}else{	
		int check[numProcess]; 	
		for( i = 0; i < cantProcess; i++){
			double row[N];
			read(pipefd[i][0], row, sizeof(double)*N);
			printf("Num: %d,  ", i);
			for(j = 0; j < N; j++ ){
				printf("%f ", row[j]);
			}
			printf("\n");
			close(pipefd[i][0]);
		}
		

		
	}	
	exit(0);


}
