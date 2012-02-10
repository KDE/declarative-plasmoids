project(tasks)


set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

find_package(KDE4 REQUIRED)
include (KDE4Defaults)
include(MacroLibrary)
include(MacroOptionalDependPackage)

macro_optional_find_package(KDE4Workspace)
macro_log_feature(KDE4WORKSPACE_FOUND "kdebase workspace" "KDE base workspace libraries" "http://www.kde.org" FALSE "" "Needed for building several Plasma plugins")

add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
add_definitions(-DQT_USE_FAST_CONCATENATION -DQT_USE_FAST_OPERATOR_PLUS)
include_directories (${KDE4_INCLUDES}
                     ${KDE4WORKSPACE_INCLUDE_DIR}
                     ${KDEPIMLIBS_INCLUDE_DIR}
                     ${CMAKE_CURRENT_SOURCE_DIR}/libs)

macro_display_feature_log()


set(tasks_SRCS tasks.cpp)

kde4_add_plugin(plasma_applet_org_kde_tasks ${tasks_SRCS})

include_directories(${KDEBASE_WORKSPACE_SOURCEDIR}/libs ${KDEBASE_WORKSPACE_SOURCEDIR}/libs/taskmanager)
target_link_libraries(plasma_applet_org_kde_tasks
                      ${KDE4_PLASMA_LIBS} ${KDE4_KDEUI_LIBS} plasmagenericshell)

install(TARGETS plasma_applet_org_kde_tasks
        DESTINATION ${PLUGIN_INSTALL_DIR})

install(FILES plasma-applet-tasks.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/packages/org.kde.tasks)
