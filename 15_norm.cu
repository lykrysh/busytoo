#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/transform_reduce.h>
#include <thrust/functional.h>
#include <cmath>
using namespace std;

template <typename T>
struct square {
	__host__ __device__ T operator()(const T &x) const
	{
		return x * x;
	}
};

int main()
{
	float hostarr[4] = {1.0, 2.0, 3.0, 4.0}; // host array
	thrust::device_vector<float> dv(hostarr, hostarr + 4); // transfered to device

	square<float> unary_op;
	thrust::plus<float> binary_op;
	float init = 0;

	float norm = sqrt(thrust::transform_reduce(dv.begin(), dv.end(), unary_op, init, binary_op));
	cout << norm << endl;
	return 0;
}

