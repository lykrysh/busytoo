#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
using namespace std;
using namespace thrust;

int main()
{
	host_vector<int> H(4);
	H[0] = 14;
	H[1] = 20;
	H[2] = 38;
	H[3] = 46;

	cout << "H's size = " << H.size() << endl;
	H.resize(2);

	for(auto i = H.begin(); i != H.end(); ++i)
		cout << *i << "\t";
	cout << endl;

	device_vector<int> D = H;
	D[0] = 99;
	D[1] = 88;

	for(auto i = D.begin(); i != D.end(); ++i)
		cout << *i << "\t";
	cout << endl;

	return 0;
}
