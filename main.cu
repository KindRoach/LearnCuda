#include "common/deviceInfo.cuh"
#include "task/algorithm/vectorAdd.cuh"
#include "task/algorithm/vectorSum.cuh"
#include "task/nestHelloWorld.cuh"
#include "task/memory/manualMemory.cuh"
#include "task/memory/pinnedMemory.cuh"
#include "task/memory/zeroCopyMemory.cuh"
#include "task/memory/unifiedMemory.cuh"
#include "task/memory/misalignedRead.cuh"


int main() {
    misalignedRead(1 << 28, 1024, 1);
}