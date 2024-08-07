vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/codecat/angelscript-mirror
    REF "7a7f62c9e35cc870f185ea5f7c0f3321135f88f3"
    PATCHES lancer_build.patch
)

vcpkg_configure_cmake(SOURCE_PATH ${SOURCE_PATH})
vcpkg_cmake_install()
