#include <stdio.h>
#include <sys/time.h>
#include <cuda_runtime.h>
#include <cuda.h>
#include <helper_cuda.h>
#include <float.h>


__global__ void matrixMult(const double *A, const double *B, double *C, int N){
	int i, j, firstRow, firstCol, assign, start, totalThreads, id;
	totalThreads = gridDim.x * blockDim.x;
	id = blockDim.x * blockIdx.x  + threadIdx.x;
	if( id < N*N ){
		assign = (N*N) / totalThreads; assign = assign < 1 ? 1:assign;
		start = id * assign;
		for( i = start; i < start+assign; i++ ){
			C[i] = 0; firstRow = (i / N)*N; firstCol = i % N;
			for( j = 0; j < N; j++ )
				C[i] += A[firstRow+j] * B[(j*N)+firstCol];
		}
	}
}

int main1(int argc, char *argv[]){
    cudaEvent_t start, stop;
    float elapsedTime;
	cudaEventCreate(&start); cudaEventRecord(start,0); // Start Measure

	int i, N = atoi(argv[1]), threadsPerBlock = atoi(argv[2]), blocksPerGrid = atoi(argv[3]);
	size_t size = sizeof(double) * (N*N);
	cudaError_t err = cudaSuccess;
	srand(time(NULL));
	threadsPerBlock = threadsPerBlock*blocksPerGrid > N*N ? (N*N/blocksPerGrid)+1 : threadsPerBlock;

	double *h_A = (double *)malloc(size);
	double *h_B = (double *)malloc(size);
	double *h_C = (double *)malloc(size);
	if (h_A == NULL || h_B == NULL || h_C == NULL){
		fprintf(stderr, "Failed to allocate host Matrix!\n");
		exit(EXIT_FAILURE);
	}

	for( i = 0; i < N*N; i++){
        h_A[i] = rand()/(double)RAND_MAX;
        h_B[i] = rand()/(double)RAND_MAX;
	}

	double *d_A = NULL;
	err = cudaMalloc((void **)&d_A, size);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to allocate device matrix A (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

	double *d_B = NULL;
	err = cudaMalloc((void **)&d_B, size);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to allocate device matrix B (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

	double *d_C = NULL;
	err = cudaMalloc((void **)&d_C, size);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to allocate device matrix C (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    err = cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to copy Matrix A from host to device (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    err = cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    if (err != cudaSuccess){
        fprintf(stderr, "Failed to copy Matrix B from host to device (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

	matrixMult<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);

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

//    for (int i = 0; i < N*N; i++){
//    	if( i%N == 0)
//    	    printf("\n");
//    	printf("%f ", h_C[i]);
//    }

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

	cudaEventCreate(&stop);  cudaEventRecord(stop,0); cudaEventSynchronize(stop); // Stop Measure
	cudaEventElapsedTime(&elapsedTime, start,stop);
	printf("        Elapsed time : %f ms\n" ,elapsedTime);
	return 0;
}
