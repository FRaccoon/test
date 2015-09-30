#include <iostream>
#include <random>

char aoj[3] = {'a', 'o', 'j'};

int main() {
	
	std::random_device rd;
	
	std::mt19937 mt(rd());
	
	char a[3];
	
	a[0] = aoj[mt()%3];
	a[1] = aoj[mt()%3];
	a[2] = aoj[mt()%3];
	
	std::cout << a[0] << a[1] << a[2];
	
	while(!(a[0]=='a' && a[1]=='o' && a[2]=='j')) {
		a[0] = a[1];
		a[1] = a[2];
		a[2] = aoj[mt()%3];
		
		std::cout << a[2];
	}
	
	std::cout << std::endl;
	
	return 0;
}