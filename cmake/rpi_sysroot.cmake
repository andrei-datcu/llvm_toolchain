include(FetchContent)
find_program(python python REQUIRED)

set(RPI_ROOTFS_ARCHIVE_BASE_URL "https://downloads.raspberrypi.org/raspios_lite_armhf/archive" CACHE STRING
    "Base URL where the raspios rootfs archive can be found")

set(RPI_ROOTFS_ARCHIVE_VERSION "2022-01-28-13:51" CACHE STRING "The version folder to append to the url")
set(RPI_ROOTFS_ARCHIVE_NAME "root.tar.xz" CACHE STRING "Name of the rootfs archive to be fetched from url")
set(RPI_ROOTFS_ARCHIVE_MD5 "db47a1407f06f8a30cb7c01f41a2d10a" CACHE STRING "Hash of the rootfs archive")

set(RPI_ROOTFS_ARCHIVE_URL ${RPI_ROOTFS_ARCHIVE_BASE_URL}/${RPI_ROOTFS_ARCHIVE_VERSION}/${RPI_ROOTFS_ARCHIVE_NAME})
MESSAGE(STATUS "RPI_ROOTFS_ARCHIVE_URL = ${RPI_ROOTFS_ARCHIVE_URL}")

set(extract_parent ${CMAKE_BINARY_DIR}/rpi-sysroot)
set(hash_cache ${extract_parent}/hash.txt)
set(extract_folder ${extract_parent}/ex)

# We directly point into usr because clang won't find libstdc++ headers (it will add an extra ..)
# There an usr link added to . in the 'links.py'
set(SYSROOT ${extract_folder}/usr)

if (EXISTS ${hash_cache})
    file(READ ${hash_cache} stored_hash)
else()
    set (stored_hash "")
endif()

if ("${stored_hash}" STREQUAL ${RPI_ROOTFS_ARCHIVE_MD5})
    message(STATUS "rpi-rootfs already extracted. Skipping extraction")
else()
    file(DOWNLOAD
        ${RPI_ROOTFS_ARCHIVE_URL} ${extract_parent}/${RPI_ROOTFS_ARCHIVE_NAME}
        SHOW_PROGRESS
        EXPECTED_MD5 ${RPI_ROOTFS_ARCHIVE_MD5}
        STATUS download_status)
    if (NOT "${download_status}" MATCHES "^0")
        list(GET ${download_status} 1 error_message)
        message(FATAL_ERROR ${error_message})
    endif()

    # extract
    file(MAKE_DIRECTORY ${extract_folder})

    execute_process(
        # limit what is extracted saving time and space and untar manually
        COMMAND ${CMAKE_COMMAND} -E tar xfJ ../${RPI_ROOTFS_ARCHIVE_NAME} -- ./usr/lib ./usr/include ./usr/bin
        WORKING_DIRECTORY ${extract_folder}
        COMMAND_ECHO STDOUT
        COMMAND_ERROR_IS_FATAL ANY
    )

    message(STATUS "Patching the extracted symlinks")
    execute_process(
        # fix links that point to absolute paths
        COMMAND ${python} ${CMAKE_SOURCE_DIR}/cmake/links.py ${SYSROOT}
        COMMAND_ERROR_IS_FATAL ANY
    )

    # Finally remove the archive
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E rm ${RPI_ROOTFS_ARCHIVE_NAME}
        WORKING_DIRECTORY ${extract_parent}
        COMMAND_ECHO STDOUT
        COMMAND_ERROR_IS_FATAL ANY
    )
    file(WRITE ${hash_cache} ${RPI_ROOTFS_ARCHIVE_MD5})
    message(STATUS "Rpi rootfs fetched and patched ok.")
endif()

configure_file(cmake/toolchain.cmake.in toolchain.cmake @ONLY)
