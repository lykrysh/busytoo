#include <stdio.h>
using namespace std;
#define N 4

__global__ void mykernel(void) {}

__global__ void add(int *a, int *b, int *sum) {
	int tid = blockIdx.x;
	if(tid < N)
		sum[tid] = a[tid] * b[tid];
}

int main() {
	mykernel<<<1,1>>>();

	int a[N],b[N],c[N];
	int *d_a, *d_b, *d_c;
	int sz = N * sizeof(int);

	cudaMalloc((void **)&d_a, sz);
	cudaMalloc((void **)&d_b, sz);
	cudaMalloc((void **)&d_c, sz);

	for(int i=0; i<N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}

	cudaMemcpy(d_a, a, sz, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sz, cudaMemcpyHostToDevice);

	add<<<N,1>>>(d_a, d_b, d_c);
	cudaMemcpy(c, d_c, sz, cudaMemcpyDeviceToHost);

	for(int i=0; i<N; i++) {
		printf("%d + %d = %d\n", a[i], b[i], c[i]);
	}

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);


	return 0;
}
