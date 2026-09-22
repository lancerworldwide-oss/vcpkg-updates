vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/lvgl/lvgl.git
    REF "80ca777e37a2b176770726a02e07a6fb79ef0b39"
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        demos    CONFIG_LV_BUILD_DEMOS
        examples CONFIG_LV_BUILD_EXAMPLES
)

set(PRIVATE_API_OPTION "")
if("demos" IN_LIST FEATURES OR "examples" IN_LIST FEATURES)
    set(PRIVATE_API_OPTION "-DCONFIG_LV_USE_PRIVATE_API=ON")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        ${PRIVATE_API_OPTION}
        -DLV_CONF_SKIP=ON
        -DLV_BUILD_LVGL_H_SYSTEM_INCLUDE=ON
        -DLV_BUILD_TESTS=OFF
        -DLV_FETCH_DEPENDENCIES=OFF
        -DLV_USE_PKG_CONFIG=OFF
        -DCONFIG_LV_USE_THORVG=OFF
        -DCONFIG_LV_USE_THORVG_INTERNAL=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/lvgl)
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENCE.txt")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
