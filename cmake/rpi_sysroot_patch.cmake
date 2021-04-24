# Cmake script that is run as a PATCH_COMMAND in a different process
# after the sysroot is fetched
# This can't live in the main script or the extraction will run
# everytime cmake is configured

set(sysroot_SOURCE_DIR ".")

find_program(python python REQUIRED)
execute_process(
    # limit what is extracted saving time and space and untar manually
    COMMAND ${CMAKE_COMMAND} -E tar xfJ ${RPI_ROOTFS_ARCHIVE_NAME} -- ./lib ./usr/lib ./usr/include ./opt/
    WORKING_DIRECTORY ${sysroot_SOURCE_DIR}
)

execute_process(
    # fix links that point to absolute paths
    COMMAND ${python} ${symlink_fixups_SOURCE_DIR}/sysroot-relativelinks.py ${sysroot_SOURCE_DIR}
    WORKING_DIRECTORY ${sysroot_SOURCE_DIR}
)
