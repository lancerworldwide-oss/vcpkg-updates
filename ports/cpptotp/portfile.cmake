vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/RavuAlHemio/cpptotp.git
    REF "696f618aec5c97970dd0948fef11cf46f7dfa255"
    PATCHES CMakeLists.patch
)

vcpkg_configure_cmake(SOURCE_PATH ${SOURCE_PATH})
vcpkg_cmake_install()
