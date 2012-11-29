project(rssnow)

find_package(KDE4 REQUIRED)

include (KDE4Defaults)
include(MacroLibrary)

include_directories (${KDE4_INCLUDES})

set(rssnow_SRCS
    rssnow.cpp
)

kde4_add_ui_files(rssnow_SRCS
    feedsConfig.ui
    generalConfig.ui
)

kde4_add_plugin(plasma_applet_rssnow ${rssnow_SRCS})

target_link_libraries(plasma_applet_rssnow
    ${KDE4_KDEUI_LIBS}
    ${KDE4_PLASMA_LIBS}
    ${QT_QTDECLARATIVE_LIBRARY}
)

install(TARGETS plasma_applet_rssnow DESTINATION ${PLUGIN_INSTALL_DIR})

#QML stuff
install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/packages/org.kde.rssnow PATTERN .svn EXCLUDE)

install(FILES plasma-applet-rssnow.desktop DESTINATION ${SERVICES_INSTALL_DIR})
