#include "lib.h"

namespace mytest {
 void Test::resize(size_t size){ this->testVec.conservativeResize(size); }
}