project(tasks-qml)


set(tasks_qml_SRCS tasks.cpp)

kde4_add_plugin(plasma_applet_tasks_qml ${tasks_qml_SRCS})
target_link_libraries(plasma_applet_tasks_qml
                      ${KDE4_PLASMA_LIBS} ${KDE4_KDEUI_LIBS})

install(TARGETS plasma_applet_tasks_qml
        DESTINATION ${PLUGIN_INSTALL_DIR})

install(FILES plasma-applet-tasks-qml.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})
