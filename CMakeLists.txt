    # project name
    project (com.github.bitseater.weather)

    # the oldest stable cmake version we support
    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.bitseater.weather")

    set (EXEC_NAME "com.github.bitseater.weather")
    set (RELEASE_NAME "Loki")
    set (VERSION "0.1")
    set (VERSION_INFO "Release")

    # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED gtk+-3.0 libsoup-2.4 json-glib-1.0 granite clutter-1.0 champlain-0.12 clutter-gtk-1.0)

    add_definitions(${DEPS_CFLAGS})
    link_libraries(${DEPS_LIBRARIES} -lm)
    link_directories(${DEPS_LIBRARY_DIRS})

    # make sure we have vala
    find_package(Vala REQUIRED)
    # make sure we use vala
    include(ValaVersion)
    # make sure it's the desired version of vala
    ensure_vala_version("0.32" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/Weather.vala
        src/MainWindow.vala
        src/Constants.vala

        src/Utils/Iconame.vala
        src/Utils/MapCity.vala
        src/Utils/OWM_Today.vala
        src/Utils/Utils.vala

        src/Widgets/City.vala
        src/Widgets/Apikey.vala
        src/Widgets/Current.vala
        src/Widgets/Header.vala
        src/Widgets/Preferences.vala
        src/Widgets/About.vala
        src/Widgets/Today.vala
        src/Widgets/Forecast.vala

    # tell what libraries to use when compiling
    PACKAGES
        gtk+-3.0
        libsoup-2.4
        json-glib-1.0
        granite
        clutter-1.0
        champlain-0.12
        clutter-gtk-1.0
    )

    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

    # install our .desktop file so the Applications menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.bitseater.weather.desktop DESTINATION ${DATADIR}/applications/)

    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.bitseater.weather.appdata.xml DESTINATION ${DATADIR}/metainfo/)

    # install application icons
    install (FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.bitseater.weather.svg" DESTINATION share/icons/hicolor/scalable/apps)

    # Translation files
    # add_subdirectory (po)
    # Native Language Support
    set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
    add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
    find_package (Gettext REQUIRED)
    file (GLOB weather_PO_FILES ${CMAKE_CURRENT_SOURCE_DIR}/po/*.po)
    gettext_create_translations (po/com.github.bitseater.weather.pot ALL ${weather_PO_FILES})

    # Disable gcc warnings
    add_definitions (-w)

    # Settings schema
    include (GSettings)
    add_schema ("/data/com.github.bitseater.weather.gschema.xml")

