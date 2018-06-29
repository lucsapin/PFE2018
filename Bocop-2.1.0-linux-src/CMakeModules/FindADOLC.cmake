#FindLIBADOLC.cmake

set(CMAKE_FIND_LIBRARY_PREFIXES "lib")

#+++ still useful ??
if(${ADOLC_VERSION} MATCHES "2.2.1")
	set(LIB_ADOLC_VERSION "1.1.1" CACHE STRING "libadolc version")
elseif(${ADOLC_VERSION} MATCHES "2.4.1")
	set(LIB_ADOLC_VERSION "1.1.1" CACHE STRING "libadolc version")
elseif(${ADOLC_VERSION} MATCHES "2.5.0" OR ${ADOLC_VERSION} MATCHES "2.5.1")
	set(LIB_ADOLC_VERSION "1.2.0" CACHE STRING "libadolc version")
elseif(${ADOLC_VERSION} MATCHES "2.5.2")
	set(LIB_ADOLC_VERSION "2.1.0" CACHE STRING "libadolc version")
endif(${ADOLC_VERSION} MATCHES "2.2.1")


# We set the libraries searching order
# Mac OS
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".dylib"   )
# Windows 
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows") 
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".dll.a" ".so")
# Linux
else()
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a")
endif()

# On linux, if there are no symbolic links in the third parties, we create them.
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux" AND EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.so.${LIB_ADOLC_VERSION} )
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.so.${LIB_ADOLC_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.so.1)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.so.${LIB_ADOLC_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.so)
endif() # Symlinks on linux 

# We comment this part because ADOL-C library is only static on Mac
# On Mac OS we have to change the install_name and create the symbolic links
#if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
#	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.${LIB_ADOLC_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.1.dylib)
#	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.${LIB_ADOLC_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.dylib)
	
#	execute_process(COMMAND install_name_tool -id ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.${LIB_ADOLC_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib/libadolc.${LIB_ADOLC_VERSION}.dylib)
#endif()

find_path(ADOLC_INCLUDE_DIR 
          NAMES adolc/adolc.h 
          PATHS ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/include
)

find_library(ADOLC_LIBRARY adolc 
             PATHS ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/lib
)

# Find colpack
find_path(COLPACK_INCLUDE_DIR
	NAMES ColPack/ColPackHeaders.h
	PATHS ${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/ThirdParty/ColPack/include
	)

find_library(COLPACK_LIBRARY ColPack 
             PATHS 	${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/ThirdParty/ColPack/lib
             		${PROJECT_SOURCE_DIR}/ThirdParty/ADOL-C-${ADOLC_VERSION}/ThirdParty/ColPack/lib64
)

if(${ADOLC_LIBRARY} MATCHES "ThirdParty")
  set(	ADOLC_LIBRARIES ${ADOLC_LIBRARY} ${COLPACK_LIBRARY})
  set(	ADOLC_INCLUDE_DIRS 
	${ADOLC_INCLUDE_DIR} 
	${ADOLC_INCLUDE_DIR}/.. 
	${ADOLC_INCLUDE_DIR}/drivers 
	${ADOLC_INCLUDE_DIR}/sparse 
	${ADOLC_INCLUDE_DIR}/tapedoc
	${COLPACK_INCLUDE_DIR}
	${COLPACK_INCLUDE_DIR}/..)
  set(ADOLC_FOUND true)
else()
  set(ADOLC_FOUND FALSE)
endif()
	
