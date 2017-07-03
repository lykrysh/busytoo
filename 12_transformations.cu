#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/replace.h>
#include <thrust/functional.h>
#include <iostream>
using namespace std;

#define N 10

int main()
{
	thrust::device_vector<int> X(N);
	thrust::device_vector<int> Y(N);
	thrust::device_vector<int> Z(N);

	thrust::sequence(X.begin(), X.end()); // 0,1,2,3...
	thrust::transform(X.begin(), X.end(), Y.begin(), thrust::negate<int>());
	thrust::fill(Z.begin(), Z.end(), 2);
	thrust::transform(X.begin(), X.end(), Z.begin(), Y.begin(), thrust::modulus<int>()); // y = x mod 2
	thrust::replace(Y.begin(), Y.end(), 1, 9);

	cout << "X: ";
	thrust::copy(X.begin(), X.end(), ostream_iterator<int>(cout, " "));
	cout << endl;

	cout << "Y: ";
	thrust::copy(Y.begin(), Y.end(), ostream_iterator<int>(cout, " "));
	cout << endl;

	cout << "Z: ";
	thrust::copy(Z.begin(), Z.end(), ostream_iterator<int>(cout, " "));
	cout << endl;

	return 0;
}
