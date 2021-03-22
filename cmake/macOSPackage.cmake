# Get reference to deployqt
get_target_property(_qmake_executable Qt${QT_VERSION_MAJOR}::qmake IMPORTED_LOCATION)
get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS "${_qt_bin_dir}")

if(NOT EXISTS ${MACDEPLOYQT_EXECUTABLE})
  message(FATAL_ERROR "Failed to locate deployqt executable")
endif()

set(CPACK_GENERATOR "Bundle")
set(CPACK_BUNDLE_NAME "Developer Mode Manager")
set(CPACK_BUNDLE_PLIST ${CMAKE_SOURCE_DIR}/deploy/macos/Info.plist)
set(CPACK_BUNDLE_ICON ${CMAKE_SOURCE_DIR}/deploy/macos/Icon.icns)

set(VERSION ${PROJECT_VERSION})
configure_file(
        ${CMAKE_SOURCE_DIR}/deploy/macos/Info.plist.in
        ${CMAKE_SOURCE_DIR}/deploy/macos/Info.plist
        @ONLY)

install(TARGETS DevModeMgr
    RUNTIME DESTINATION ../MacOS
)

install(DIRECTORY ${NODE_DIR} DESTINATION ../)
install(DIRECTORY ${ARES_CLI_DIR} DESTINATION ../)

include(CPack)
