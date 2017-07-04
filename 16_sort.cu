#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <thrust/functional.h>
#include <iostream>
using namespace std;

#define N 6

int main()
{
	int A[N] = {1,4,2,8,5,7};
	char B[N] = {'b', 'a', 'h', 'j', 'd', 'c'};

	thrust::device_vector<int> D(N);
	thrust::device_vector<char> E(N);

	thrust::copy(A, A+N, D.begin());
	thrust::copy(B, B+N, E.begin());
//	thrust::sort(D.begin(), D.end());
//	thrust::stable_sort(D.begin(), D.end(), thrust::greater<int>());
//	thrust::sort_by_key(D.begin(), D.end(), E.begin());
	thrust::sort_by_key(D.begin(), D.end(), E.begin(), thrust::greater<int>());

	thrust::copy(D.begin(), D.end(), ostream_iterator<int>(cout, " "));
	cout << endl;
	thrust::copy(E.begin(), E.end(), ostream_iterator<char>(cout, " "));
	cout << endl;


	return 0;
}
