cmake_minimum_required(VERSION 3.10.2)

project(Proj_1_1 LANGUAGES CXX)

set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)  # configure for run time.(on target device)
set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib:%ORIGIN/lib")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)


# configure for build time (on host deivce)
find_package(Qt5 COMPONENTS Core Quick Concurrent Network Svg LinguistTools Multimedia REQUIRED)

find_library(MODBUS_LIB
    NAMES modbus
    PATHS /usr/lib/aarch64-linux-gnu
)

add_executable(${PROJECT_NAME}
    main.cpp
    modbusmanager.cpp
    modbusmanager.h
    weathermanager.cpp
    weathermanager.h
    languagemanager.cpp
    languagemanager.h
    networkhelper.cpp
    networkhelper.h
    asrengine.cpp
    asrengine.h
    qml.qrc
#    voicecontroller.cpp
#    voicecontroller.h
    )

target_include_directories(${PROJECT_NAME} PRIVATE
    /usr/include
    /usr/include/modbus
    ${CMAKE_SOURCE_DIR}/3rdparty/sherpa-onnx/include)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::Concurrent
    Qt5::Network
    Qt5::Svg
    Qt5::Multimedia
    ${MODBUS_LIB}
    ${CMAKE_SOURCE_DIR}/3rdparty/sherpa-onnx/lib/libsherpa-onnx-c-api.so
)

include(GNUInstallDirs)
install(TARGETS Proj_1_1
    DESTINATION /root/Downloads)
