#include <stdio.h>

int main() {
	int num_dev;
	cudaGetDeviceCount(&num_dev);

	printf("%d\n", num_dev);

	return 0;
}
