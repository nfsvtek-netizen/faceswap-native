cmake_minimum_required(VERSION 3.18.1)
project("facewarp")

add_library(facewarp SHARED native-lib.cpp)

find_library(log-lib log)

target_link_libraries(facewarp ${log-lib})

if(ANDROID_ABI STREQUAL "armeabi-v7a")
    set_target_properties(facewarp PROPERTIES COMPILE_FLAGS "-mfpu=neon")
endif()
