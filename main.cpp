#include <Eigen/Dense>
#include <iostream>
#include "lib/lib.h"

int main(int argc, char const *argv[]) {
  int initialSize;
  std::cout << "Type initial size: ";
  std::cin >> initialSize;
  mytest::Test obj = mytest::Test(initialSize);

  std::cout << std::endl << "Type new size: ";
  int newSize;
  std::cin >> newSize;
  obj.resize(newSize);

  std::cout << std::endl << "Type new size: ";
  std::cin >> newSize;
  obj.resize(newSize);

  Eigen::VectorXd testVec = obj.getVec();
  for (int i = 0; i < testVec.size(); ++i) {
    std::cout << testVec[i] << std::endl;
  }

  return 0;
}
