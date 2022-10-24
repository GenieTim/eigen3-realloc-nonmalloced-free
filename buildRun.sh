#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 10
ROOT_DIR=$(pwd)

mkdir -p build
cd build || exit 5

if [[ $OSTYPE == 'darwin'* ]]; then
  CXXCOMPILER=$(which clang++ || which g++)
  CCOMPILER=$(which clang || which gcc)
else
  CXXCOMPILER=$(which g++ || which clang++)
  CCOMPILER=$(which gcc || which clang)
fi

ADDITIONALFLAGS=("${ADDITIONALFLAGS[@]}" -D CODE_COVERAGE=ON -D LEAK_ANALYSIS=ON -D CMAKE_C_COMPILER="$CCOMPILER" -D CMAKE_CXX_COMPILER="$CXXCOMPILER")

GENERATOR_BIN="make"
if command -v ninja; then
  ADDITIONALFLAGS=("${ADDITIONALFLAGS[@]}" "-GNinja")
  GENERATOR_BIN="ninja"
fi

cmake .. "${ADDITIONALFLAGS[@]}" || exit 1
cmake --build . || exit 9
MallocNanoZone=0 ASAN_OPTIONS=detect_leaks=1:detect_container_overflow=0:strict_string_checks=1:detect_stack_use_after_return=1:check_initialization_order=1:strict_init_order=1 ./main
