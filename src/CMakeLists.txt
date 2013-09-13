### CMakeLists automatically created with AutoVala
### Do not edit

if(${CMAKE_INSTALL_PREFIX} MATCHES usr/local/? )
	set( AUTOVALA_INSTALL_PREFIX "/usr/local")
else()
	set( AUTOVALA_INSTALL_PREFIX "/usr")
endif()

STRING (REPLACE "/" ";" AUTOVALA_PATH_LIST ${CMAKE_INSTALL_PREFIX})
SET (FINAL_AUTOVALA_PATH "")

FOREACH(element ${AUTOVALA_PATH_LIST})
	IF (${FOUND_USR})
		SET(FINAL_AUTOVALA_PATH ${FINAL_AUTOVALA_PATH}/.. )
	ELSE()
		IF(${element} STREQUAL "usr")
			SET(FOUND_USR 1)
			SET(FINAL_AUTOVALA_PATH ${FINAL_AUTOVALA_PATH}.. )
		ENDIF()
	ENDIF()
ENDFOREACH()

set (DATADIR "${AUTOVALA_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/tabletlauncher")
set (GETTEXT_PACKAGE "tabletlauncher")
set (RELEASE_NAME "tabletlauncher")
set (CMAKE_C_FLAGS "")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (VERSION "1.0.0")
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
set (VERSION "1.0.0")
add_definitions(${DEPS_CFLAGS})
link_libraries( ${DEPS_LIBRARIES} )
link_directories( ${DEPS_LIBRARY_DIRS} )
find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.18" MINIMUM)
include(ValaPrecompile)

set(VALA_PACKAGES
	gee-1.0
	gio-unix-2.0
	glib-2.0
	gtk+-3.0
)

set(APP_SOURCES
	${CMAKE_CURRENT_BINARY_DIR}/Config.vala
	desktop.vala
	tabletlauncher.vala
)

vala_precompile(VALA_C tabletlauncher
	${APP_SOURCES}
PACKAGES
	${VALA_PACKAGES}
CUSTOM_VAPIS
	${CUSTOM_VAPIS_LIST}
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
