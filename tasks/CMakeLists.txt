project(dictionary)

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.tasks-qml PATTERN .svn EXCLUDE)

install(FILES plasma-applet-tasks-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
