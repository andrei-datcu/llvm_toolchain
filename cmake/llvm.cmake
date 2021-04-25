include(ExternalProject)

set(LLVM_GIT_TAG "llvmorg-12.0.0" CACHE STRING "LLVM version used for TARGET libs")

ExternalProject_Add(llvm
    GIT_REPOSITORY https://github.com/llvm/llvm-project.git
    GIT_TAG        ${LLVM_GIT_TAG}
    GIT_SHALLOW    ON
    SOURCE_SUBDIR  llvm
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake
        -DCMAKE_CXX_FLAGS=-fuse-ld=lld
        -DCMAKE_C_FLAGS=-fuse-ld=lld
        -DLIBCXXABI_ENABLE_SHARED=OFF
        -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
        -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
        -DLIBCXX_INCLUDE_BENCHMARKS=OFF
        -DLLVM_INCLUDE_BENCHMARKS=OFF
        -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;clang-tools-extra;lldb"
        -DDEFAULT_SYSROOT=${sysroot_SOURCE_DIR}
        -C$<TARGET_PROPERTY:llvm,SOURCE_DIR>/clang/cmake/caches/CrossWinToARMLinux.cmake 
)
