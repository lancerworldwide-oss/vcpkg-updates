vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/codecat/angelscript-mirror
    REF "7a7f62c9e35cc870f185ea5f7c0f3321135f88f3"
    PATCHES
        lancer_build.patch
        mingw-windows-h.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/AngelScript)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/sdk/docs/doxygen/source/doc_license.h")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
