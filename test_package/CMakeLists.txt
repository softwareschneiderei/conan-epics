project(PackageTest CXX)
cmake_minimum_required(VERSION 2.8.12)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(SKIP_RPATH)

find_package(EPICS REQUIRED)
find_package(Threads REQUIRED)

add_executable(example example.cpp)
target_link_libraries(example ${CONAN_LIBS} ${EPICS_LIBRARIES} Threads::Threads ${CMAKE_DL_LIBS})
target_include_directories(example PRIVATE ${EPICS_INCLUDE_DIR})