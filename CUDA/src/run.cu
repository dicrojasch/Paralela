#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#include <helper_cuda.h>


int main(void){
    cudaError_t err = cudaSuccess;
    int N, threads, blocks, multiP = 0, cores = 0, i;
    int deviceCount = 0;
    err = cudaGetDeviceCount(&deviceCount);
    if (err != cudaSuccess){
		printf("cudaGetDeviceCount returned %d\n-> %s\n", (int)err, cudaGetErrorString(err));
		printf("Result = FAIL\n");
		exit(EXIT_FAILURE);
	}
    if (deviceCount == 0){
		printf("There are no available device(s) that support CUDA\n");
		exit(1);
	}
    cudaSetDevice(0);
    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, 0);
    multiP = deviceProp.multiProcessorCount;
    cores = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor);
    printf("Multiprocessors(MP): %d , Cores x MP: %d \n", multiP, cores);
    char commandBase[12] = "./src/mult ";



    for( N = 8; N < 1025; N += N ){
    	printf("Matrix %d x %d\n",N,N);
    	for( blocks = 1; blocks <= multiP; blocks++ ){
    		printf("  Block %d\n",blocks);
    		for( threads = 32; threads < 1025; threads += threads ){
    		    char partialCommand[30] = "";
    		    char toChar[15] = "";
    			printf("    Thread %d\n", threads);
    			strcat( partialCommand, commandBase);
    			sprintf(toChar, "%d %d %d", N, threads, blocks);
    			strcat( partialCommand, toChar);
    			for(i = 1; i < 11; i++ ){
    				printf("      Repeticion %d\n",i);
    				system(partialCommand);
    			}
    		}
    	}
    }



    return 0;
}

