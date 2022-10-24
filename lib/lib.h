#ifndef MY_TEST_LIB
#define MY_TEST_LIB

#include <Eigen/Dense>

namespace mytest {

class Test {
public:
  Test(size_t size) { this->testVec = Eigen::VectorXd::Zero(size); }

  void resize(size_t size);

  Eigen::VectorXd getVec() { return this->testVec; }

private:
  Eigen::VectorXd testVec;
};
} // namespace mytest
#endif