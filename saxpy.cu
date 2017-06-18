#include <stdio.h>

__global__ void saxpy(uint n, float a, float *x, float *y) {
  uint i = blockIdx.x*blockDim.x + threadIdx.x; // nvcc built-ins
  if(i < n)
    y[i] = a*x[i] + y[i];
  }

void misc(void) {
  int ndev;
  cudaDeviceProp prop;
  cudaGetDeviceCount(&ndev);
  printf("This machine has %d CUDA devices.\n", ndev);
  for(int i = 0; i < ndev; i++) {
    const char *indent = (ndev == 0) ? "" : "  ";
    cudaGetDeviceProperties(&prop, i);
    if(ndev > 0)
      printf("Device %d:\n", i);
    printf("%sdevice.name = %s\n", indent, prop.name);
    printf("%sdevice.maxThreadsPerBlock = %d\n", indent, prop.maxThreadsPerBlock);
  }
}

int main(int argc, char **argv) {
  uint n = atoi(argv[1]);
  int size = n*sizeof(float);
  float *x, *y, *yy; 
  float *dev_x, *dev_y;

  misc();
  x = (float *)malloc(size);
  y = (float *)malloc(size);
  yy = (float *)malloc(size);

  for(int i = 0; i < n; i++) {
    x[i] = i;
    y[i] = i*i;
  }

  cudaMalloc((void**)(&dev_x), size);
  cudaMalloc((void**)(&dev_y), size);
  cudaMemcpy(dev_x, x, size, cudaMemcpyHostToDevice);
  cudaMemcpy(dev_y, y, size, cudaMemcpyHostToDevice);

  float a = 3.0;
  saxpy<<<ceil(n/256.0),256>>>(n, a, dev_x, dev_y);
  cudaMemcpy(yy, dev_y, size, cudaMemcpyDeviceToHost);

  for(int i = 0; i < n; i++) { // check the result
    if(yy[i] != a*x[i] + y[i]) {
      fprintf(stderr, "ERROR: i=%d, a = %s, x[i]=%f, y[i]=%f, yy[i]=%f\n",
	      i, a, x[i], y[i], yy[i]);
      exit(-1);
    }
  }
  printf("The results match!\n");

  free(x);
  free(y);
  free(yy);
  cudaFree(dev_x);
  cudaFree(dev_y);
  exit(0);
}
