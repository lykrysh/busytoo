#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/reduce.h>
#include <thrust/count.h>
#include <thrust/functional.h>
#include <thrust/execution_policy.h>
#include <thrust/scan.h>
#include <iostream>
using namespace std;

#define N 10

int main()
{
	thrust::device_vector<int> D(N);
	thrust::sequence(D.begin(), D.end());

	int nines = thrust::count(D.begin(), D.end(), 9);
	int sum1, sum2, sum3;
	sum1 = thrust::reduce(D.begin(), D.end(), (int)0, thrust::plus<int>());
	sum2 = thrust::reduce(D.begin(), D.end(), (int)0); // same
	sum3 = thrust::reduce(D.begin(), D.end()); // same
	cout << nines << " " << sum1 << " " << sum2 << " " << sum3 << endl;

	int data[N] = {1,2,3,1,2,3,1,2,3,1}; // can use reduce for normal array!
	int sum4 = thrust::reduce(data, data + N);
	int sum5 = thrust::reduce(thrust::host, data, data + N, -1, thrust::maximum<int>());
	cout << sum4 << " " << sum5 << endl;

	int hostarr[N] = {1,2,3,4,5,1,2,3,4,5};
	thrust::inclusive_scan(hostarr, hostarr + N, hostarr);
	thrust::inclusive_scan(D.begin(), D.end(), D.begin());
	thrust::copy(D.begin(), D.end(), ostream_iterator<int>(cout, " "));
	cout << endl;

	return 0;
}
