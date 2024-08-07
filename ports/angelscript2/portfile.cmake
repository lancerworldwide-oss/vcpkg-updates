vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL ssh://git@engineering.lancerworldwide.com:7990/extern/angelscript.git
    REF 1e0a872a9d5d6c2890dba6250d94feb667db6d29
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/AngelScript)


vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/docs/manual/doc_license.html")
