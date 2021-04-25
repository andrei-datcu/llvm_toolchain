cmake_minimum_required(VERSION 3.19.0)
project(clang_toolchain)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "MinSizeRel" CACHE STRING "Choose the type of build, options are: Debug, Release, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to MinSizeRel.")
endif()

# set(CMAKE_CXX_SIMULATE_ID "") # Cmake was setting this to MSVC even if we had the Clang with GNU interface selected
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE INTERNAL "Where to install the toolchain")

set(TARGET_TRIPLE "arm-linux-gnueabihf" CACHE STRING "Target Triple")
# set(TARGET_FLOAT_ABI "hard" CACHE STRING "Value of -mfloat-abi")
# set(TARGET_FPU "neon-vfpv4" CACHE STRING "Value of -mfpu")

set(CMAKE_C_COMPILER_TARGET ${TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${TARGET_TRIPLE})

include ("./cmake/rpi_sysroot.cmake")

# add_compile_options(-target ${TARGET_TRIPLE} --sysroot ${sysroot_SOURCE_DIR}
#     -mfloat-abi=${TARGET_FLOAT_ABI} -mfpu=${TARGET_FPU})
# add_link_options(-v -fuse-ld=lld)

include ("./cmake/llvm.cmake")
