project(news)

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.kde.news-qml PATTERN .svn EXCLUDE)
install(FILES active-news-reader.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

install(FILES plasma-applet-news-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
