cmake_minimum_required(VERSION 3.19.0) # You need 3.21 at least for windows in order for the install to work
project(clang_toolchain)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "MinSizeRel" CACHE STRING "Choose the type of build, options are: Debug, Release, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to MinSizeRel.")
endif()

set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE INTERNAL "Where to install the toolchain")

set(TARGET_TRIPLE "arm-unknown-linux-gnueabihf" CACHE STRING "Target Triple")
set(TARGET_TRIPLE_NO_SUB "arm-linux-gnueabihf" CACHE STRING "Target Triple without arch sub type")
set(TARGET_TRIPLE_WITH_VENDOR "arm-unknown-linux-gnueabihf" CACHE STRING "Target Triple without arch sub type")
set(TARGET_ARCH "ARM")

set(CMAKE_C_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${TARGET_TRIPLE})

include ("./cmake/rpi_sysroot.cmake")
include ("./cmake/llvm.cmake")

install(DIRECTORY ${SYSROOT}/ DESTINATION sysroot)
install(DIRECTORY ${LLVM_TEMP_INSTALL_DIR}/ DESTINATION sysroot)

install(DIRECTORY ${LLVM_TEMP_INSTALL_DIR}/lib/${TARGET_TRIPLE}/ DESTINATION sysroot/lib/${TARGET_TRIPLE_NO_SUB})
install(DIRECTORY ${LLVM_TEMP_INSTALL_DIR}/lib/clang/13.0.1/lib/${TARGET_TRIPLE}/
    DESTINATION sysroot/lib/clang/13.0.1/lib/${TARGET_TRIPLE_WITH_VENDOR})
install(DIRECTORY ${LLVM_TEMP_INSTALL_DIR}/include/${TARGET_TRIPLE}/ DESTINATION sysroot/include)
