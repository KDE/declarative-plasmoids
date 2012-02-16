find_package(KDE4 REQUIRED)

include(KDE4Defaults)

add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
include_directories(
      ${CMAKE_SOURCE_DIR}
      ${CMAKE_BINARY_DIR}
      ${KDE4_INCLUDES})


add_subdirectory(rssnow)
add_subdirectory(dictionary)
add_subdirectory(knowledgebase)
add_subdirectory(news)
add_subdirectory(social-news)
add_subdirectory(microblog)
