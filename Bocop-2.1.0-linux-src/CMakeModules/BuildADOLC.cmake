# This code is published under the Eclipse Public License
# Authors: Daphne Giorgi, Pierre Martinon, Olivier Tissot
# Inria Saclay and Cmap Ecole Polytechnique
# 2014-2017


# Set paths to ThirdParty codes
set(THIRDPARTY_DIR ${BOCOP_SOURCE_DIR}/ThirdParty)
set(ADOLC_DIR ${THIRDPARTY_DIR}/ADOL-C-${ADOLC_VERSION})
set(COLPACK_DIR ${THIRDPARTY_DIR}/ADOL-C-${ADOLC_VERSION}/ThirdParty/ColPack-${COLPACK_VERSION})


########################################
# B. BUILD COLPACK AND ADOLC IF NEEDED #
########################################

#############
# B.1 COLPACK
IF(NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib AND NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib64)
message("\nBuild ColPack. This will be done only once.\n\n")

# WINDOWS BUILD 
IF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
# NB. changes in configure (try to find the correct options, run configure twice to remove the need for the sed commands ??)
# enable_dlopen=yes
# enable_win32_dll=yes
# enable_shared=yes
# enable_static=no x2
# enable_shared_with_static_runtimes=yes
# enable_shared_with_static_runtimes_CXX=yes

message(FATAL "old script does not work with recent mingw. Use cmake anyway...")
#execute_process(COMMAND cp ${BOCOP_SOURCE_DIR}/windows/configure.colpack ${COLPACK_DIR}/configure;)			  
#execute_process(COMMAND sh configure --prefix=${ADOLC_DIR}/ThirdParty/ColPack --libdir=${ADOLC_DIR}/ThirdParty/ColPack/lib 
#		--disable-static --enable-shared WORKING_DIRECTORY ${COLPACK_DIR}	RESULT_VARIABLE retvarconf)
# Dynamic lib, necessary to link with ADOL-C +++ recheck lines !
#execute_process(COMMAND  sed "5547s/yes/no/" INPUT_FILE ${COLPACK_DIR}/libtool OUTPUT_FILE ${COLPACK_DIR}/libtool.temp RESULT_VARIABLE retvarsed)      
#execute_process(COMMAND  sed "5550s/yes/no/" INPUT_FILE ${COLPACK_DIR}/libtool.temp OUTPUT_FILE ${COLPACK_DIR}/libtool RESULT_VARIABLE retvarsed)
#execute_process(COMMAND make WORKING_DIRECTORY ${COLPACK_DIR})
#execute_process(COMMAND make install WORKING_DIRECTORY ${COLPACK_DIR})
# Now we build the static lib, in order be able to link with bocop.exe (+++just rerun configure with different options ?) +++ recheck lines !
#execute_process(COMMAND  sed "5547s/no/yes/" INPUT_FILE ${COLPACK_DIR}/libtool OUTPUT_FILE ${COLPACK_DIR}/libtool.temp RESULT_VARIABLE retvarsed)
#execute_process(COMMAND  sed "5550s/no/yes/" INPUT_FILE ${COLPACK_DIR}/libtool.temp	OUTPUT_FILE ${COLPACK_DIR}/libtool RESULT_VARIABLE retvarsed)
#execute_process(COMMAND mv libColPack.la libColPack.la.temp WORKING_DIRECTORY ${COLPACK_DIR})
#execute_process(COMMAND make WORKING_DIRECTORY ${COLPACK_DIR})
#execute_process(COMMAND make install WORKING_DIRECTORY ${COLPACK_DIR})
#execute_process(COMMAND mv libColPack.la.temp ../ColPack/lib/libColPack.la WORKING_DIRECTORY ${COLPACK_DIR})
 
# LINUX / MAC BUILD       
ELSE(${CMAKE_SYSTEM_NAME} MATCHES "Windows")

  # aclocal/autoconf step does not work on all platforms, try to use common configure...
  #execute_process(COMMAND aclocal WORKING_DIRECTORY ${COLPACK_DIR})
  #execute_process(COMMAND sh autoconf.sh WORKING_DIRECTORY ${COLPACK_DIR})
  execute_process(COMMAND ./configure --prefix=${ADOLC_DIR}/ThirdParty/ColPack 
  --libdir=${ADOLC_DIR}/ThirdParty/ColPack/lib	WORKING_DIRECTORY ${COLPACK_DIR} RESULT_VARIABLE retvarconf)
  execute_process(COMMAND make -j WORKING_DIRECTORY ${COLPACK_DIR})	
  execute_process(COMMAND make install WORKING_DIRECTORY ${COLPACK_DIR})
  execute_process(COMMAND cp -r ${ADOLC_DIR}/ThirdParty/ColPack/lib ${ADOLC_DIR}/ThirdParty/ColPack/lib64;)

ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")

ENDIF(NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib AND NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib64)

# Check lib +++refine
IF(NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib AND NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib64)
  message(FATAL_ERROR "Colpack build failed...")
ENDIF(NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib AND NOT EXISTS ${ADOLC_DIR}/ThirdParty/ColPack/lib64)


###########
# B.2 ADOLC 
IF(NOT EXISTS ${ADOLC_DIR}/lib)
message("\nBuild Adol-C. This will be done only once.\n\n")

file(MAKE_DIRECTORY ${ADOLC_DIR} ${ADOLC_DIR}/build)
# c++11 required for ADOLC > 2.5.0 (+++still needed if done in root CMakeLists ?)
IF(ADOLC_VERSION VERSION_GREATER 2.5)
  set(ADDITIONAL_FLAGS "${ADDITIONAL_FLAGS} --with-cxxflags='-std=c++11' " )
ENDIF()

# define external project
SET(CMAKE_LIST_CONTENT_ADOLC "
 	cmake_minimum_required(VERSION 2.8)
	include(ExternalProject)  
	ExternalProject_Add( 3-Adolc_external
			SOURCE_DIR ${ADOLC_DIR} CONFIGURE_COMMAND ${ADOLC_DIR}/configure 
			--prefix=${ADOLC_DIR} --enable-sparse --with-colpack=${ADOLC_DIR}/ThirdParty/ColPack 
			--libdir=${ADOLC_DIR}/lib	${ADDITIONAL_FLAGS})
	")

# save CMakeLists.txt
file(WRITE ${ADOLC_DIR}/CMakeLists.txt "${CMAKE_LIST_CONTENT_ADOLC}")

# configure (windows or linux/mac)
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  execute_process(COMMAND ${CMAKE_COMMAND} -G "MSYS Makefiles" ..	WORKING_DIRECTORY ${ADOLC_DIR}/build)
else(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  execute_process(COMMAND ${CMAKE_COMMAND} ..	WORKING_DIRECTORY ${ADOLC_DIR}/build)
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")

# make & make install
execute_process(COMMAND ${CMAKE_COMMAND} --build . -- -j WORKING_DIRECTORY ${ADOLC_DIR}/build)
        
ENDIF(NOT EXISTS ${ADOLC_DIR}/lib)

