vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/lvgl/lvgl.git
    REF "80ca777e37a2b176770726a02e07a6fb79ef0b39"
    PATCHES
        patches/0001-sdl-skip-expose-redraw.patch
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

set(LV_CONF_H "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-lv_conf.h")

if(VCPKG_TARGET_IS_EMSCRIPTEN)
    file(WRITE "${LV_CONF_H}" [[
#ifndef LV_CONF_H
#define LV_CONF_H
#endif
]])
    set(LVGL_DRIVER_OPTIONS
        -DLV_USE_FIND_PACKAGE_SDL2=OFF
    )
elseif(VCPKG_TARGET_IS_WINDOWS)
    file(WRITE "${LV_CONF_H}" [[
#ifndef LV_CONF_H
#define LV_CONF_H
#define LV_MEM_SIZE (2 * 1024U * 1024U)
#define LV_USE_SDL 1
#define LV_SDL_DIRECT_EXIT 0
#define LV_USE_WINDOWS 1
#define LV_USE_FS_STDIO 1
#define LV_FS_STDIO_LETTER 'A'
#define LV_USE_MATRIX 1
#define LV_USE_VECTOR_GRAPHIC 1
#define LV_USE_THORVG 1
#define LV_USE_THORVG_INTERNAL 1
#define LV_USE_SVG 1
#endif
]])
    set(LVGL_DRIVER_OPTIONS
        -DLV_USE_FIND_PACKAGE_SDL2=ON
    )
elseif(VCPKG_TARGET_IS_LINUX)
    file(WRITE "${LV_CONF_H}" [[
#ifndef LV_CONF_H
#define LV_CONF_H
#define LV_MEM_SIZE (2 * 1024U * 1024U)
#define LV_USE_SDL 1
#define LV_SDL_DIRECT_EXIT 0
#define LV_USE_X11 1
#define LV_USE_LINUX_DRM 1
#define LV_USE_LINUX_FBDEV 1
#define LV_USE_WAYLAND 1
#define LV_WAYLAND_DIRECT_EXIT 0
#define LV_USE_EVDEV 1
#define LV_USE_LIBINPUT 1
#define LV_LIBINPUT_XKB 1
#define LV_USE_FFMPEG 1
#define LV_USE_GSTREAMER 1
#define LV_USE_FS_STDIO 1
#define LV_FS_STDIO_LETTER 'A'
#define LV_USE_MATRIX 1
#define LV_USE_VECTOR_GRAPHIC 1
#define LV_USE_THORVG 1
#define LV_USE_THORVG_INTERNAL 1
#define LV_USE_SVG 1
#endif
]])
    set(LVGL_DRIVER_OPTIONS
        -DLV_USE_FIND_PACKAGE_SDL2=ON
        -DLV_USE_PKG_CONFIG_X11=ON
        -DLV_USE_PKG_CONFIG_LIBDRM=ON
        -DLV_USE_PKG_CONFIG_WAYLAND=ON
        -DLV_USE_PKG_CONFIG_EVDEV=ON
        -DLV_USE_PKG_CONFIG_LIBINPUT=ON
        -DLV_USE_PKG_CONFIG_XKBCOMMON=ON
        -DLV_USE_PKG_CONFIG_FFMPEG=ON
        -DLV_USE_PKG_CONFIG_GSTREAMER=ON
    )
    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        if(DEFINED ENV{PKG_CONFIG_PATH} AND NOT "$ENV{PKG_CONFIG_PATH}" STREQUAL "")
            set(ENV{PKG_CONFIG_PATH} "/usr/lib/aarch64-linux-gnu/pkgconfig:$ENV{PKG_CONFIG_PATH}")
        else()
            set(ENV{PKG_CONFIG_PATH} "/usr/lib/aarch64-linux-gnu/pkgconfig")
        endif()
    endif()
else()
    file(WRITE "${LV_CONF_H}" [[
#ifndef LV_CONF_H
#define LV_CONF_H
#endif
]])
    set(LVGL_DRIVER_OPTIONS
        -DLV_USE_FIND_PACKAGE_SDL2=OFF
    )
endif()

vcpkg_find_acquire_program(PYTHON3)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        ${PRIVATE_API_OPTION}
        ${LVGL_DRIVER_OPTIONS}
        -DLV_CONF_SKIP=OFF
        "-DLV_BUILD_CONF_PATH=${LV_CONF_H}"
        -DLV_BUILD_SET_CONFIG_OPTS=ON
        -DLV_BUILD_LVGL_H_SYSTEM_INCLUDE=ON
        -DLV_BUILD_TESTS=OFF
        -DLV_FETCH_DEPENDENCIES=OFF
        -DCONFIG_LV_USE_THORVG=ON
        -DCONFIG_LV_USE_THORVG_INTERNAL=ON
        "-DPython_EXECUTABLE=${PYTHON3}"
    MAYBE_UNUSED_VARIABLES
        LV_USE_FIND_PACKAGE_SDL2
        LV_USE_PKG_CONFIG_X11
        LV_USE_PKG_CONFIG_LIBDRM
        LV_USE_PKG_CONFIG_WAYLAND
        LV_USE_PKG_CONFIG_EVDEV
        LV_USE_PKG_CONFIG_LIBINPUT
        LV_USE_PKG_CONFIG_XKBCOMMON
        LV_USE_PKG_CONFIG_FFMPEG
        LV_USE_PKG_CONFIG_GSTREAMER
        Python_EXECUTABLE
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

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/include/lvgl/demos/benchmark/assets"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/demos/music/assets/png/272_png"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/demos/music/assets/png/480_png"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/demos/render/assets"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/demos/vector_graphic/assets"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/demos/widgets/assets/font"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/arduino/LVGL_Arduino"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/assets/emoji"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/get_started/get_started_hello_world"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/get_started/get_started_slider"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/get_started/get_started_styles"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/libs/qrcode/qrcode_basic"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/xml_project/fonts"
    "${CURRENT_PACKAGES_DIR}/include/lvgl/examples/xml_project/images"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/drivers/display/mipi"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/drivers/opengles/glad/src"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/font/tiny_ttf"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/libs/gltf/fastgltf"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/logging"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/stdlib/clib"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/stdlib/micropython"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/stdlib/rtthread"
    "${CURRENT_PACKAGES_DIR}/include/lvgl_private/stdlib/uefi"
)
