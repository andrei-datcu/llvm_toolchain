include(ExternalProject)

set(LLVM_GIT_TAG "llvmorg-12.0.0" CACHE STRING "LLVM version used for TARGET libs")


# This is the default value, but we need to use it in CMAKE_ARGS
set(LLVM_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/llvm-prefix/src/llvm)

ExternalProject_Add(llvm
    GIT_REPOSITORY https://github.com/llvm/llvm-project.git
    GIT_TAG        ${LLVM_GIT_TAG}
    GIT_SHALLOW    ON
    SOURCE_DIR     ${LLVM_SOURCE_DIR}
    SOURCE_SUBDIR  llvm
    USES_TERMINAL_DOWNLOAD ON
    USES_TERMINAL_CONFIGURE ON
    USES_TERMINAL_BUILD ON
    USES_TERMINAL_INSTALL ON
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake # used for any host os
        -DCMAKE_BUILD_TYPE=Release
        # The compiler to build the native llvm/clang tools must be cl.exe on windows
        # The native tools need to be built before the target tools are built
        -DCROSS_TOOLCHAIN_FLAGS_NATIVE=-DCMAKE_C_COMPILER=cl.exe$<SEMICOLON>-DCMAKE_CXX_COMPILER=cl.exe 
        -DLLVM_DEFAULT_TARGET_TRIPLE=${TARGET_TRIPLE}
        -DLLVM_TARGET_ARCH=${TARGET_ARCH}
        -DLLVM_TARGETS_TO_BUILD=${TARGET_ARCH}
        -DLLVM_HOST_TRIPLE=${TARGET_TRIPLE} # This may look werid, but it's correct. Used by lldb
        -DLLVM_TARGETS_TO_BUILD=${TARGET_ARCH} # No cross-compile capabilities needed for the built toolchain
        -DLLVM_ENABLE_PROJECTS=#clang$<SEMICOLON>lldb
        -DLLVM_ENABLE_RUNTIMES=libunwind$<SEMICOLON>#compiler-rt$<SEMICOLON>libcxxabi$<SEMICOLON>libcxx
        -DLLVM_DISTRIBUTION_COMPONENTS=#builtins$<SEMICOLON>clang$<SEMICOLON>runtimes$<SEMICOLON>lldb
        # LLVM options
        -DLLVM_ENABLE_LIBXML2=OFF
        -DLLVM_ENABLE_ZLIB=OFF
        -DLLDB_ENABLE_PYTHON=0
        -DLLDB_ENABLE_LIBEDIT=0
        -DLLDB_ENABLE_CURSES=0
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_INCLUDE_GO_TESTS=OFF
        -DLLVM_INCLUDE_DOCS=OFF
        -DLLVM_ENABLE_OCAMLDOC=OFF
        -DLLVM_ENABLE_BINDINGS=OFF
        -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_INCLUDE_BENCHMARKS=OFF
        -DDEFAULT_SYSROOT=${SYSROOT}

        # Runtimes options
        -DBUILTINS_CMAKE_ARGS=-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake
        -DRUNTIMES_CMAKE_ARGS=-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake$<SEMICOLON>-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON

        -DLIBUNWIND_USE_COMPILER_RT=ON
        -DLIBUNWIND_TARGET_TRIPLE=${TARGET_TRIPLE}
        -DLIBUNWIND_SYSROOT=${SYSROOT}

        -DLIBCXXABI_USE_LLVM_UNWINDER=ON
        -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
        -DLIBCXXABI_USE_COMPILER_RT=ON
        -DLIBCXXABI_TARGET_TRIPLE=${TARGET_TRIPLE}
        -DLIBCXXABI_SYSROOT=${sysroot_SOURCE_DIR}/usr

        -DLIBCXX_USE_COMPILER_RT=ON
        -DLIBCXX_TARGET_TRIPLE=${TARGET_TRIPLE}
        -DLIBCXX_SYSROOT=${sysroot_SOURCE_DIR}/usr
        -DLIBCXX_INCLUDE_BENCHMARKS=OFF
        #-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
)
