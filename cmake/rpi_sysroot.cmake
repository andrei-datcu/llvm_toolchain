include(FetchContent)

set(RPI_ROOTFS_ARCHIVE_BASE_URL "https://downloads.raspberrypi.org/raspios_armhf/archive" CACHE STRING
    "Base URL where the raspios rootfs archive can be found")

set(RPI_ROOTFS_ARCHIVE_VERSION "2021-03-25-14:44" CACHE STRING "The version folder to append to the url")
set(RPI_ROOTFS_ARCHIVE_NAME "root.tar.xz" CACHE STRING "Name of the rootfs archive to be fetched from url")
set(RPI_ROOTFS_ARCHIVE_MD5 "F4CF3DE4E145EAF11DBEAE9E50EC549E" CACHE STRING "Hash of the rootfs archive")

set(RPI_ROOTFS_ARCHIVE_URL ${RPI_ROOTFS_ARCHIVE_BASE_URL}/${RPI_ROOTFS_ARCHIVE_VERSION}/${RPI_ROOTFS_ARCHIVE_NAME})
MESSAGE(STATUS "RPI_ROOTFS_ARCHIVE_URL = ${RPI_ROOTFS_ARCHIVE_URL}")

# Script that changes the symlinks that point to absolute paths to point to relative paths
FetchContent_Declare(symlink_fixups
    URL https://raw.githubusercontent.com/Kukkimonsuta/rpi-buildqt/master/scripts/utils/sysroot-relativelinks.py
    DOWNLOAD_NO_EXTRACT ON
    DOWNLOAD_NAME "sysroot-relativelinks.py"
    URL_HASH MD5=d9eb93ccb6fcb1f9778fd7aaa845c667
)

if (NOT symlink_fixups_POPULATED)
    FetchContent_Populate(symlink_fixups)
endif()


FetchContent_Declare(sysroot
    URL ${RPI_ROOTFS_ARCHIVE_URL}
    URL_MD5 ${RPI_ROOTFS_ARCHIVE_MD5}
    DOWNLOAD_NO_EXTRACT ON
    DOWNLOAD_NAME ${RPI_ROOTFS_ARCHIVE_NAME}
    PATCH_COMMAND ${CMAKE_COMMAND} -DRPI_ROOTFS_ARCHIVE_NAME=${RPI_ROOTFS_ARCHIVE_NAME} -Dsymlink_fixups_SOURCE_DIR=${symlink_fixups_SOURCE_DIR} -P "${CMAKE_SOURCE_DIR}/cmake/rpi_sysroot_patch.cmake"
)

if (NOT sysroot_POPULATED)
    FetchContent_Populate(sysroot)
    configure_file(cmake/toolchain.cmake.in toolchain.cmake @ONLY)
endif()
