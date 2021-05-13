cmake_minimum_required(VERSION 3.19.0) # You need 3.21 at least for windows in order for the install to work
project(clang_toolchain)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "MinSizeRel" CACHE STRING "Choose the type of build, options are: Debug, Release, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to MinSizeRel.")
endif()

set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE INTERNAL "Where to install the toolchain")

set(TARGET_TRIPLE "armv7-linux-gnueabihf" CACHE STRING "Target Triple")
set(TARGET_ARCH "ARM")

set(CMAKE_C_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${TARGET_TRIPLE})

include ("./cmake/rpi_sysroot.cmake")
include ("./cmake/llvm.cmake")

install(DIRECTORY ${SYSROOT}/ DESTINATION sysroot)
install(DIRECTORY ${LLVM_TEMP_INSTALL_DIR}/ DESTINATION sysroot)
# libc++ is installed with c++ suffix and it won't get picked up automatically
install(DIRECTORY ${LLVM_TEMP_INSTALL_DIR}/lib/${TARGET_TRIPLE}/c++/ DESTINATION sysroot/lib)
