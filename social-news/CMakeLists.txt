project(social-news)

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.social-news-qml PATTERN .svn EXCLUDE)

install(FILES plasma-applet-social-news-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
