project(rssnow)

install(DIRECTORY contents DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.microblog-qml/ PATTERN .svn EXCLUDE)
install(DIRECTORY platformcontents DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.microblog-qml/ PATTERN .svn EXCLUDE)
install(FILES metadata.desktop DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.microblog-qml)
install(FILES active-microblog.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

install(FILES plasma-applet-microblog-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
install(FILES active-microblog.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})
