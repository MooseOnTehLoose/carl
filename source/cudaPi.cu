#include <unistd.h>
#include <stdio.h>
#include <iostream>
#include <cstdlib>
#include <errno.h>
#include <math.h>
#include <ctime>
#include <curand.h>
#include <curand_kernel.h>

__global__ void init(float time, curandState_t* states){
    int threadID = threadIdx.x + blockDim.x * blockIdx.x; 
    curand_init ( time,  threadID, 0, &states[threadID] );
}

__global__ void getRandNums(curandState *states, int* randNums) {
    int threadID = threadIdx.x + blockDim.x * blockIdx.x; 
    float x = curand_uniform(&states[threadID]);
    float y = curand_uniform(&states[threadID]);
    float dx = abs(.5 - x);
    float dy = abs(.5 - y);
    float distance = sqrt ( dx * dx + dy * dy);

    if (.5 > distance){
        randNums[threadID] = 1;
    }
    else {
        randNums[threadID] = 0;
    }

}

int main(int argc, char* argv[]) {

    //default number of blocks if not specified via command line
    long int blocks = 256;
    //number of threads per block, max is 1024 on an nvidia m40
    int bThreads = 512;
    
    long int arg1 = 0;
    errno = 0;
    char *endIn = NULL;
    
    if ( argc >= 2){
        arg1 = strtol(argv[1], &endIn, 10);
        if (arg1 != 0 || errno == 0 ){
            blocks = arg1;  
        }
    } else {
        std::cout << "Number of blocks not specified, using default 256" << std::endl;
    }
    
    //total threads is needed for size of the arrays and later for monte-carlo approximation
    int tThreads = blocks * bThreads;
    std::cout << "Blocks: " << blocks << " Total Threads: " << tThreads << std::endl;

    curandState_t *states;
    cudaMallocManaged(&states, tThreads * sizeof(curandState_t));
    init<<<blocks, bThreads>>>(time(0), states);

    int* randNums;
    cudaMallocManaged(&randNums, tThreads * sizeof(long int));
    getRandNums<<<blocks, bThreads>>>(states, randNums);

    cudaDeviceSynchronize();
    
    int insidePoints = 0;
    for (int i = 0; i < tThreads; i++) {
        if (randNums[i] == 1){
            insidePoints++;
        }
    }

    float pi = 4 * (static_cast<double>(insidePoints) / static_cast<double>(tThreads));
    std::cout << "Pi is approx: " << pi << std::endl;
    
    cudaFree(states);
    cudaFree(randNums);

    return 0;
}
