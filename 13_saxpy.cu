#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/fill.h>
#include <thrust/copy.h>
#include <thrust/functional.h>
#include <iostream>
using namespace std;

#define N 10


typedef thrust::device_vector<float> dVecFloat;

void saxpy_slow(float a, dVecFloat &X, dVecFloat &Y)
{
	dVecFloat temp(X.size());
	thrust::fill(temp.begin(), temp.end(), a); // temp <- a
	thrust::transform(X.begin(), X.end(), temp.begin(), temp.begin(), thrust::multiplies<float>()); // temp <- temp * x
	thrust::transform(temp.begin(), temp.end(), Y.begin(), Y.begin(), thrust::plus<float>()); // y <- temp + y
}

// better way
struct saxpy_functor
{
	const float a;
	saxpy_functor(float _a) : a(_a) {}
	__host__ __device__ float operator()(const float &x, const float &y) const
	{
		return a * x + y;
	}
};

void saxpy_fast(float a, dVecFloat &X, dVecFloat &Y)
{
	thrust::transform(X.begin(), X.end(), Y.begin(), Y.begin(), saxpy_functor(a));
}

int main()
{
	dVecFloat X(N), Y(N);
	float a = 3.4;
	thrust::sequence(X.begin(), X.end());
	thrust::fill(Y.begin(), Y.end(), 5);
	saxpy_fast(a, X, Y);
//	saxpy_slow(a, X, Y);

	cout << "Y: ";
	thrust::copy(Y.begin(), Y.end(), ostream_iterator<float>(cout, " "));
	cout << endl;

	return 0;
}
