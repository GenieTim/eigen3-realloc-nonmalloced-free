cmake_minimum_required(VERSION 3.10)
cmake_policy(SET CMP0077 NEW)

# set the project name
project(naub_lib VERSION 1.0)
add_library(naub_lib naub_lib.cpp)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# TODO: remove
# set(CMAKE_CXX_FLAGS "-pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wdisabled-optimization -Wformat=2 -Winit-self -Wmissing-declarations -Wmissing-include-dirs -Wold-style-cast -Woverloaded-virtual -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo -Wstrict-overflow=5 -Wswitch-default -Wundef -Wno-unused -g")

# add libraries
if (DEFINED ADDITIONAL_INCLUDES)
	include_directories(ADDITIONAL_INCLUDES)
endif()

if (DEFINED ADDITIONAL_LIBS)
	link_directories(ADDITIONAL_LIBS)
endif()

# add dependencies
include(${CMAKE_CURRENT_SOURCE_DIR}/../vendor/eigen.CMakeLists.cmake)

# add_dependencies(naub_lib Eigen3::Eigen)

# link Eigen libraries. Difficulty due to Windows GitHub Action, somehow.
if (TARGET Eigen3::Eigen)
	message(STATUS "Target Eigen3::Eigen found")
	target_link_libraries(naub_lib PUBLIC Eigen3::Eigen)
else()
	include_directories(${EIGEN3_INCLUDE_DIRS})
	include_directories(${EIGEN3_INCLUDE_DIRS}/eigen3)
	target_link_libraries(naub_lib PUBLIC ${EIGEN3_LIBRARIES})
	message(STATUS "Eigen include directories: ${EIGEN3_INCLUDE_DIRS}, libraries ${EIGEN3_LIBRARIES}")
endif()
# Eigen3::Eigen 

# optional additional dependencies
find_package(OpenMP)
if (OpenMP_FOUND AND OpenMP_INCLUDE_DIRS)
  include_directories(${OpenMP_INCLUDE_DIRS})
	target_link_libraries(naub_lib PRIVATE ${OpenMP_LIBRARIES})
	add_definitions(-DOPENMP_FOUND=true)
	message(INFO "Found OpenMP")
else()
	message("Did not find OpenMP")
endif()

target_sources(naub_lib
	PRIVATE
		${CMAKE_CURRENT_LIST_DIR}/lib.cpp
	PUBLIC
		${CMAKE_CURRENT_LIST_DIR}/lib.h
)

set_target_properties(naub_lib PROPERTIES VERSION ${PROJECT_VERSION})


# add other needed packages
# target_link_libraries(naub_lib 
# 	PRIVATE
# )
# target_link_libraries(naub_lib ${igraph_LIBRARIES})
