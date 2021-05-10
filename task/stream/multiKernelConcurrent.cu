//
// Created by kindr on 2021/5/8.
//

#include "multiKernelConcurrent.cuh"
#include "../../common/utils.cuh"
#include <cstdio>

const int N = 1 << 25;

__global__
void kernel1() {
    double sum = 0;
    for (int i = 0; i < N; i++) sum += tan(0.1) * tan(0.1);
    printf("sum=%g\n", sum);
}

__global__
void kernel2() {
    double sum = 0;
    for (int i = 0; i < N; i++) sum += tan(0.1) * tan(0.1);
    printf("sum=%g\n", sum);
}

void multiKernelConcurrent() {

    int n_stream = 4;
    size_t nStreamBytes = n_stream * sizeof(cudaStream_t);
    auto *stream = static_cast<cudaStream_t *>(malloc(nStreamBytes));
    for (int i = 0; i < n_stream; i++) {
        cudaStreamCreate(&stream[i]);
    }
    CHECK(cudaGetLastError());

    for (int i = 0; i < n_stream; i++) {
        kernel1<<<1, 1, 0, stream[i]>>>();
        kernel2<<<1, 1, 0, stream[i]>>>();
    }

    for (int i = 0; i < n_stream; i++) {
        kernel1<<<1, 1>>>();
        kernel2<<<1, 1>>>();
    }

    cudaDeviceSynchronize();
    CHECK(cudaGetLastError());

    for (int i = 0; i < n_stream; i++) {
        cudaStreamDestroy(stream[i]);
    }

    free(stream);
}
