#include <stdio.h>
#include <cuda_runtime.h>

#include <helper_cuda.h>


int main1(void){
    cudaError_t err = cudaSuccess;
    int multiP = 0, cores = 0;

    // Measure time
    cudaEvent_t start, stop;
    float elapsedTime;
    cudaEventCreate(&start); cudaEventRecord(start,0); // Start Measure

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
    printf("%d , %d \n",multiP, cores);


    cudaEventCreate(&stop);  cudaEventRecord(stop,0); cudaEventSynchronize(stop); // Stop Measure
    cudaEventElapsedTime(&elapsedTime, start,stop);
    printf("Elapsed time : %f ms\n" ,elapsedTime);
    return 0;
}

