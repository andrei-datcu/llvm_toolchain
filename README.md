# llvm_toolchain
Build a llvm toolchain from a sysroot (currently RPI) and a target triple


# Windows
1) Install Ninja, the latest llvm distribution and the latest Visual Studio
2) From a VS Developer PowerShell: `cmake .. -G Ninja; ninja; ninja install`

The Visual Studio compiler is used to build the Windows binaries (such as table-gen) that are then used to build the final target toolchain. The installed llvm distribution is used for cross-compiling.
