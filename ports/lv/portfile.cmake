vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/aptumfr/lv.git
    REF "e6b0adbd33b63d617334dc536245e5fe42c2518e"
    PATCHES
        install-cmake.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/lv-config.cmake.in" DESTINATION "${SOURCE_PATH}/cmake")

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        std-function LV_CPP_USE_STD_FUNCTION
)

set(VCPKG_BUILD_TYPE release)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        "-DLVGL_DIR=${CURRENT_INSTALLED_DIR}"
        -DLV_BUILD_EXAMPLES=OFF
        -DLV_BUILD_DEMOS=OFF
        -DLV_BUILD_TESTS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/lv)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
