# eigen3-realloc-nonmalloced-free

This is a minimal reproducible example of a strange error (possibly related to compilation procedure).
The behaviour shows an error by the AddressSanitizer in Eigen internal code, namely a "free on address which was not malloc(ed)" when trying to realloc. The free is called 16 bytes further than it should.

The error you should see after cloning and running `buildRun.sh` and typing two random numbers is listed below.

Some notes
- this error seems to only occur with gcc, not clang
- reproduced on multiple devices
- the CMake configuration might be relevant, though no "solving change" was found yet
- the fact that the realloc is called into a library is relevant (all code in one file does not trigger the issue)
- the sizes of the vector are not relevant (or, at least, no numbers were found yet, where the error would not occur)


```
Type initial size: 7

Type new size: 9
=================================================================
==4495==ERROR: AddressSanitizer: attempting free on address which was not malloc()-ed: 0x607000000110 in thread T0
    #0 0x7f6244599c3e in __interceptor_realloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cc:163
    #1 0x55c5b550ab52 in Eigen::internal::aligned_realloc(void*, unsigned long, unsigned long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5b52)
    #2 0x55c5b550acfc in void* Eigen::internal::conditional_aligned_realloc<true>(void*, unsigned long, unsigned long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5cfc)
    #3 0x55c5b550acc3 in double* Eigen::internal::conditional_aligned_realloc_new_auto<double, true>(double*, unsigned long, unsigned long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5cc3)
    #4 0x55c5b550ac32 in Eigen::DenseStorage<double, -1, -1, 1, 0>::conservativeResize(long, long, long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5c32)
    #5 0x55c5b550abf1 in Eigen::internal::conservative_resize_like_impl<Eigen::Matrix<double, -1, 1, 0, -1, 1>, Eigen::Matrix<double, -1, 1, 0, -1, 1>, true>::run(Eigen::DenseBase<Eigen::Matrix<double, -1, 1, 0, -1, 1> >&, long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5bf1)
    #6 0x55c5b550aba6 in Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, -1, 1> >::conservativeResize(long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5ba6)
    #7 0x55c5b550aa7c in mytest::Test::resize(unsigned long) ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x5a7c)
    #8 0x55c5b5508682 in main {path_to_this_repo_clone}/EigenReallocTest/main.cpp:18
    #9 0x7f6243f72082 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x24082)
    #10 0x55c5b550840d in _start ({path_to_this_repo_clone}/EigenReallocTest/build/main+0x340d)

0x607000000110 is located 16 bytes inside of 72-byte region [0x607000000100,0x607000000148)
allocated by thread T0 here:
    #0 0x7f6244599808 in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cc:144
    #1 0x55c5b5508bb0 in Eigen::internal::handmade_aligned_malloc(unsigned long, unsigned long) {path_to_eigen3_src}/Eigen/src/Core/util/Memory.h:105
    #2 0x55c5b5508c91 in Eigen::internal::aligned_malloc(unsigned long) {path_to_eigen3_src}/Eigen/src/Core/util/Memory.h:188
    #3 0x55c5b550a0a8 in void* Eigen::internal::conditional_aligned_malloc<true>(unsigned long) {path_to_eigen3_src}/Eigen/src/Core/util/Memory.h:241
    #4 0x55c5b5509e9e in double* Eigen::internal::conditional_aligned_new_auto<double, true>(unsigned long) {path_to_eigen3_src}/Eigen/src/Core/util/Memory.h:404
    #5 0x55c5b550a9cb in Eigen::DenseStorage<double, -1, -1, 1, 0>::resize(long, long, long) {path_to_eigen3_src}/Eigen/src/Core/DenseStorage.h:639
    #6 0x55c5b550a82b in Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, -1, 1> >::resize(long, long) {path_to_eigen3_src}/Eigen/src/Core/PlainObjectBase.h:285
    #7 0x55c5b550a534 in void Eigen::internal::resize_if_allowed<Eigen::Matrix<double, -1, 1, 0, -1, 1>, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> >, double, double>(Eigen::Matrix<double, -1, 1, 0, -1, 1>&, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > const&, Eigen::internal::assign_op<double, double> const&) {path_to_eigen3_src}/Eigen/src/Core/AssignEvaluator.h:764
    #8 0x55c5b550a3c9 in void Eigen::internal::call_dense_assignment_loop<Eigen::Matrix<double, -1, 1, 0, -1, 1> >(Eigen::Matrix<double, -1, 1, 0, -1, 1>&, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<Eigen::Matrix<double, -1, 1, 0, -1, 1>::Scalar>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > const&, Eigen::internal::assign_op<Eigen::Matrix<double, -1, 1, 0, -1, 1>::Scalar, Eigen::Matrix<double, -1, 1, 0, -1, 1>::Scalar> const&) {path_to_eigen3_src}/Eigen/src/Core/AssignEvaluator.h:793
    #9 0x55c5b550a2a6 in Eigen::internal::Assignment<Eigen::Matrix<double, -1, 1, 0, -1, 1>, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> >, Eigen::internal::assign_op<double, double>, Eigen::internal::Dense2Dense, void>::run(Eigen::Matrix<double, -1, 1, 0, -1, 1>&, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > const&, Eigen::internal::assign_op<double, double> const&) {path_to_eigen3_src}/Eigen/src/Core/AssignEvaluator.h:954
    #10 0x55c5b550a089 in void Eigen::internal::call_assignment_no_alias<Eigen::Matrix<double, -1, 1, 0, -1, 1>, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> >, Eigen::internal::assign_op<double, double> >(Eigen::Matrix<double, -1, 1, 0, -1, 1>&, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > const&, Eigen::internal::assign_op<double, double> const&) {path_to_eigen3_src}/Eigen/src/Core/AssignEvaluator.h:890
    #11 0x55c5b5509e4f in void Eigen::internal::call_assignment<Eigen::Matrix<double, -1, 1, 0, -1, 1>, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> >, Eigen::internal::assign_op<double, double> >(Eigen::Matrix<double, -1, 1, 0, -1, 1>&, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > const&, Eigen::internal::assign_op<double, double> const&, Eigen::internal::enable_if<!Eigen::internal::evaluator_assume_aliasing<Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> >, Eigen::internal::evaluator_traits<Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > >::Shape>::value, void*>::type) {path_to_eigen3_src}/Eigen/src/Core/AssignEvaluator.h:858
    #12 0x55c5b5509af7 in void Eigen::internal::call_assignment<Eigen::Matrix<double, -1, 1, 0, -1, 1>, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > >(Eigen::Matrix<double, -1, 1, 0, -1, 1>&, Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > const&) {path_to_eigen3_src}/Eigen/src/Core/AssignEvaluator.h:836
    #13 0x55c5b55096b4 in Eigen::Matrix<double, -1, 1, 0, -1, 1>& Eigen::PlainObjectBase<Eigen::Matrix<double, -1, 1, 0, -1, 1> >::_set<Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > >(Eigen::DenseBase<Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > > const&) {path_to_eigen3_src}/Eigen/src/Core/PlainObjectBase.h:779
    #14 0x55c5b5509342 in Eigen::Matrix<double, -1, 1, 0, -1, 1>& Eigen::Matrix<double, -1, 1, 0, -1, 1>::operator=<Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > >(Eigen::DenseBase<Eigen::CwiseNullaryOp<Eigen::internal::scalar_constant_op<double>, Eigen::Matrix<double, -1, 1, 0, -1, 1> > > const&) {path_to_eigen3_src}/Eigen/src/Core/Matrix.h:225
    #15 0x55c5b5508e65 in mytest::Test::Test(unsigned long) {path_to_this_repo_clone}/EigenReallocTest/lib/lib.h:10
    #16 0x55c5b5508606 in main {path_to_this_repo_clone}/EigenReallocTest/main.cpp:13
    #17 0x7f6243f72082 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x24082)

SUMMARY: AddressSanitizer: bad-free ../../../../src/libsanitizer/asan/asan_malloc_linux.cc:163 in __interceptor_realloc
==4495==ABORTING
```