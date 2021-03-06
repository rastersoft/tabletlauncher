### CMakeLists automatically created with AutoVala
### Do not edit

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/tabletlauncher")
set (GETTEXT_PACKAGE "tabletlauncher")
set (RELEASE_NAME "tabletlauncher")
set (CMAKE_C_FLAGS "")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (VERSION "0.8.0")
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
set (VERSION "0.8.0")
add_definitions (${DEPS_CFLAGS})
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.20" MINIMUM)
include (ValaPrecompile)

set (VALA_PACKAGES ${VALA_PACKAGES} gee-1.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gio-unix-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gtk+-3.0)

set (APP_SOURCES ${APP_SOURCES} ${CMAKE_CURRENT_BINARY_DIR}/Config.vala)
set (APP_SOURCES ${APP_SOURCES} desktop.vala)
set (APP_SOURCES ${APP_SOURCES} tabletlauncher.vala)
set (APP_SOURCES ${APP_SOURCES} ui.vala)

vala_precompile(VALA_C tabletlauncher
	${APP_SOURCES}
PACKAGES
	${VALA_PACKAGES}
)

add_executable(tabletlauncher ${VALA_C})

install(TARGETS
	tabletlauncher
RUNTIME DESTINATION
	bin/
)

if(HAVE_VALADOC)
	valadoc(tabletlauncher
		${CMAKE_BINARY_DIR}/valadoc/tabletlauncher
		${APP_SOURCES}
	PACKAGES
		${VALA_PACKAGES}
	CUSTOM_VAPIS
		${CUSTOM_VAPIS_LIST}
	)
	install(DIRECTORY
		${CMAKE_BINARY_DIR}/valadoc
	DESTINATION
		share/doc/tabletlauncher
	)
endif()
