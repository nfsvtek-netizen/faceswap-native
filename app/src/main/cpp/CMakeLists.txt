cmake_minimum_required(VERSION 3.18.1)
project("facewarp")

add_library(facewarp SHARED native-lib.cpp)

# Standard system libraries
find_library(log-lib log)

# NCNN — link the prebuilt SCRFD/NCNN shared library shipped with the APK.
# The .so is available for all ABIs in the decompiled APK assets; CMake will
# resolve it from the project's jniLibs directory at build time.
find_library(ncnn-lib ncnn)
find_library(vulkan-lib vulkan)
find_library(pthread pthread)

# Link all dependencies into the facewarp shared library.
# Order matters: facewarp → ncnn (GPU backend) → vulkan → pthread → log
target_link_libraries(facewarp
    ${ncnn-lib}
    ${vulkan-lib}
    ${pthread}
    ${log-lib}
)

# NEON is enabled by default on arm64-v8a; armv7 needs explicit flag.
if(ANDROID_ABI STREQUAL "armeabi-v7a")
    set_target_properties(facewarp PROPERTIES COMPILE_FLAGS "-mfpu=neon")
endif()
