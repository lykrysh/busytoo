#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/fill.h>
#include <thrust/sequence.h>
#include <thrust/copy.h>
#include <list>
#include <vector>

using namespace std;

#define N 10

int main()
{
	thrust::device_vector<int> D(N, 1);
	thrust::fill(D.begin(), D.begin() + 7, 9); // 9 9 9 9 9 9 9 1 1 1

	thrust::host_vector<int> H(D.begin(), D.begin() + 5); // 9 9 9 9 9
	thrust::sequence(H.begin(), H.end()); // 0 1 2 3 4

	// copy all H to D
	thrust::copy(H.begin(), H.end(), D.begin());

	// can copy back to H
	H.resize(N);
	thrust::copy(D.begin(), D.end(), H.begin());

	cout << "H is: ";
	for(auto i = H.begin(); i != H.end(); ++i)
		cout << *i << " ";
	cout << endl;

	cout << "D is: ";
	for(auto i = D.begin(); i != D.end(); ++i)
		cout << *i << " ";
	cout << endl;

	// OK to use regular vector too
	vector<int> regular(N);
	thrust::copy(D.begin(), D.end(), regular.begin());

	cout << "Regular vec is: ";
	for(auto i = regular.begin(); i != regular.end(); ++i)
		cout << *i << " ";
	cout << endl;

	///////////////////////////////////////////////////////////////////
	// how to use raw pointer to device mem
	int *ptr;
	cudaMalloc((void **) &ptr, N * sizeof(int));
	thrust::device_ptr<int> dev_ptr(ptr);
	//then we can do this
	thrust::fill(dev_ptr, dev_ptr + N, (int)99);

	cout << "Raw ptr is: ";
	for(auto i = dev_ptr; i != dev_ptr + N; ++i)
		cout << *i << " ";
	cout << endl;

	// how to extract raw pointer from device pointer (then what?)
	thrust::device_ptr<int> dev_ptr2 = thrust::device_malloc<int> (N);
	int *ptr2 = thrust::raw_pointer_cast(dev_ptr2);
	int *ptr3 = thrust::raw_pointer_cast(dev_ptr);

	// segfault below

	/*
	cout << "Casted ptr is: ";
	for(auto i = ptr2; i != ptr2 + N; ++i)
		cout << *i << " ";
	cout << endl;
	*/

	/////////////////////////////////////////////////////////////////
	// however using iterator (compared to pointer) is better choice for traversing
	list<int> lst;
	lst.push_back(10);
	lst.push_back(20);
	lst.push_back(30);
	lst.push_back(40);

	thrust::device_vector<int> DD(lst.begin(), lst.end());

	cout << "DD is: ";
	for(auto i = DD.begin(); i != DD.end(); ++i)
		cout << *i << " ";
	cout << endl;

	return 0;
}
