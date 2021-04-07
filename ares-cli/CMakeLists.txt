cmake_minimum_required(VERSION 3.10)

include(ExternalProject)

if(MSVC OR MSYS OR MINGW)
    set(NODEJS_BIN_URL "https://nodejs.org/dist/v14.16.0/node-v14.16.0-win-x64.zip")
    set(NODEJS_BIN_HASH "716045c2f16ea10ca97bd04cf2e5ef865f9c4d6d677a9bc25e2ea522b594af4f")
elseif(CMAKE_HOST_APPLE)
    set(NODEJS_BIN_URL "https://nodejs.org/dist/v14.16.0/node-v14.16.0-darwin-x64.tar.gz")
    set(NODEJS_BIN_HASH "14ec767e376d1e2e668f997065926c5c0086ec46516d1d45918af8ae05bd4583")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(NODEJS_BIN_URL "https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz")
    set(NODEJS_BIN_HASH "2e079cf638766fedd720d30ec8ffef5d6ceada4e8b441fc2a093cb9a865f4087")
else()
    message(FATAL_ERROR "Unsupported platform ${CMAKE_SYSTEM_NAME}")
endif()

ExternalProject_Add(node
    PREFIX ${CMAKE_SYSTEM_NAME}

    URL ${NODEJS_BIN_URL}
    URL_HASH SHA256=${NODEJS_BIN_HASH}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

set(NODE_DIR ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_SYSTEM_NAME}/src/node)

if(MSVC OR MSYS OR MINGW)
    set(NODE_BIN ${NODE_DIR}/node)
    set(NPM_PROGRAM ${NODE_DIR}/npm)
else()
    set(NODE_BIN ${NODE_DIR}/bin/node)
    set(NPM_PROGRAM ${NODE_BIN} ${NODE_BIN}/npm)
endif()

ExternalProject_Add(ares-cli
    PREFIX ${CMAKE_SYSTEM_NAME}

    DOWNLOAD_COMMAND ${NPM_PROGRAM} install --prefix ares-cli @webosose/ares-cli
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""

    DEPENDS node
)


set(NODE_BIN ${NODE_BIN} PARENT_SCOPE)
set(ARES_CLI_DIR ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_SYSTEM_NAME}/src/ares-cli/node_modules/@webosose/ares-cli PARENT_SCOPE)
set(ARES_CLI_PATH ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_SYSTEM_NAME}/src/ares-cli/node_modules/@webosose/ares-cli/bin PARENT_SCOPE)
