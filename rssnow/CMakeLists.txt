project(rssnow)

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.rssnow-qml PATTERN .svn EXCLUDE)

install(FILES plasma-applet-rssnow-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
