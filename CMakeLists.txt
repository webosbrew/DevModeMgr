cmake_minimum_required(VERSION 3.10)

project(DevModeMgr LANGUAGES CXX
    VERSION 0.1.0
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package(...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

add_subdirectory(ares-cli)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick REQUIRED)

set(PROJECT_SOURCES
        src/main.cpp
        src/model/DeviceListModel.cpp
        src/service/DeviceManager.cpp
        src/qml/qml.qrc
        src/res/res.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(DevModeMgr
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(DevModeMgr SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(DevModeMgr
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(DevModeMgr
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(DevModeMgr
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)
target_compile_definitions(DevModeMgr PRIVATE
  NODE_BIN="${NODE_BIN}" ARES_CLI_PATH="${ARES_CLI_PATH}")

if(MSVC OR MSYS OR MINGW)
    include(WindowsPackage)
elseif(CMAKE_HOST_APPLE)
    include(macOSPackage)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")

else()
    message(FATAL_ERROR "Unsupported platform ${CMAKE_SYSTEM_NAME}")
endif()
