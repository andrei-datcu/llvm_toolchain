include(FetchContent)

set(LLVM_GIT_TAG "llvmorg-12.0.0" CACHE STRING "LLVM version used for TARGET libs")

FetchContent_Declare(llvm
    GIT_REPOSITORY https://github.com/llvm/llvm-project.git
    GIT_TAG        ${LLVM_GIT_TAG}
    GIT_SHALLOW    ON
)

if (NOT llvm_POPULATED)
    FetchContent_Populate(llvm)

    ##### 1) libunwind
    set(LIBUNWIND_ENABLE_SHARED OFF)
    add_subdirectory(
        ${llvm_SOURCE_DIR}/libunwind ${llvm_BINARY_DIR}/libunwind
    )

    ##### 2) compiler-rt
    set(COMPILER_RT_INSTALL_PATH ${CMAKE_INSTALL_PREFIX})
    add_subdirectory(
        ${llvm_SOURCE_DIR}/compiler-rt ${llvm_BINARY_DIR}/compiler-rt
    )
    
    ##### 3) libcxxabi
    set(LIBCXXABI_USE_LLVM_UNWINDER ON)
    set(LIBCXXABI_ENABLE_STATIC_UNWINDER ON)
    set(LIBCXXABI_ENABLE_SHARED OFF)
    set(LIBCXX_INCLUDE_BENCHMARKS OFF)
    add_subdirectory(
        ${llvm_SOURCE_DIR}/libcxxabi ${llvm_BINARY_DIR}/libcxxabi
    )

    ##### 4) libcxx
    set(LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON)
    set(LIBCXXABI_USE_LLVM_UNWINDER ON)
    set(LIBCXX_ENABLE_SHARED OFF)
    set(LIBCXX_ENABLE_EXPERIMENTAL_LIBRARY OFF)
    add_subdirectory(
        ${llvm_SOURCE_DIR}/libcxx ${llvm_BINARY_DIR}/libcxx
    )
endif()
