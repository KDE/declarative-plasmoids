project(dictionary)

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.dictionary-qml PATTERN .svn EXCLUDE)

install(FILES plasma-applet-dictionary-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
