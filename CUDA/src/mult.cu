#include <stdio.h>
#include<sys/time.h>
#include <cuda_runtime.h>
#include <cuda.h>
#include <helper_cuda.h>
#include <float.h>


__global__ void matrixMult(const double *A, const double *B, double *C, int sizeMatrix){
	int i, j;
	int totalThreads = gridDim.x * blockDim.x;
	int id = blockDim.x * blockIdx.x  + threadIdx.x;
	int assign = sizeMatrix / totalThreads;
	assign = assign < 0 ? 1:assign;
	int start = id * assign;
	int firstRow = 0, firstCol = 0;
	for( i = start; i < assign; i++ ){
		C[i] = 0;
		firstRow = (i+1)/ sizeMatrix;
		firstCol = i % sizeMatrix;
		for( j = 0; j < sizeMatrix; j++ )
			C[i] += A[firstRow+j] * B[(j*sizeMatrix)+firstCol];
		if( i > (assign-1) &&  ((assign*totalThreads + id) < sizeMatrix)){
			i = assign*totalThreads + id;
			assign = i + 1;
		}
	}
}

int main(int argc, char *argv[]){
	cudaError_t err = cudaSuccess;
	int threadsPerBlock = atoi(argv[1]), N = atoi(argv[2]), blocksPerGrid = atoi(argv[3]);
	int i, size;
	srand(time(NULL));

	size = sizeof(double) * (N*N);


	double *h_A = (double *)malloc(size);
	double *h_B = (double *)malloc(size);
	double *h_C = (double *)malloc(size);
	if (h_A == NULL || h_B == NULL || h_C == NULL){
		fprintf(stderr, "Failed to allocate host Matrix!\n");
		exit(EXIT_FAILURE);
	}

	for( i = 0; i < N*N; i++){
		h_A[i] = rand()/(float)RAND_MAX;
		h_B[i] = rand()/(float)RAND_MAX;
	}

	double *d_A = (double *)malloc(size);
	err = cudaMalloc((void **)&d_A, size);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to allocate device matrix A (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

	double *d_B = (double *)malloc(size);
	err = cudaMalloc((void **)&d_B, size);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to allocate device matrix B (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

	double *d_C = (double *)malloc(size);
	err = cudaMalloc((void **)&d_C, size);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to allocate device matrix C (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    err = cudaMemcpy(h_A, d_A, size, cudaMemcpyHostToDevice);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to copy Matrix A from host to device (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    err = cudaMemcpy(h_B, d_B, size, cudaMemcpyHostToDevice);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to copy Matrix B from host to device (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    matrixMult<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N*N);
    err = cudaGetLastError();

    if (err != cudaSuccess){
        fprintf(stderr, "Failed to launch kernel (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    err = cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to copy matrix C from device to host (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < N; i++){
    	printf("%d ", h_C[i]);
    	if( i%N == 0){
    		printf("\n");
    	}
    }

    err = cudaFree(d_A);
	if (err != cudaSuccess){
		fprintf(stderr, "Failed to free device vector A (error code %s)!\n", cudaGetErrorString(err));
		exit(EXIT_FAILURE);
	}

	err = cudaFree(d_B);
	if (err != cudaSuccess){
		fprintf(stderr, "Failed to free device vector B (error code %s)!\n", cudaGetErrorString(err));
		exit(EXIT_FAILURE);
	}

	err = cudaFree(d_C);
	if (err != cudaSuccess){
		fprintf(stderr, "Failed to free device vector C (error code %s)!\n", cudaGetErrorString(err));
		exit(EXIT_FAILURE);
	}

	free(h_A);
	free(h_B);
	free(h_C);
	return 0;
}
