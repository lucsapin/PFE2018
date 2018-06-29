# This code is published under the Eclipse Public License
# Authors: Daphne Giorgi, Pierre Martinon, Olivier Tissot
# Inria Saclay and Cmap Ecole Polytechnique
# 2014-2017


# Set paths to ThirdParty codes
set(THIRDPARTY_DIR ${BOCOP_SOURCE_DIR}/ThirdParty)
set(IPOPT_DIR ${THIRDPARTY_DIR}/Ipopt-${IPOPT_VERSION})


############################
# A. BUILD IPOPT IF NEEDED #
############################
IF(NOT EXISTS ${IPOPT_DIR}/lib)
message("Build Ipopt. This will be done only once.\n\n")

file(MAKE_DIRECTORY ${IPOPT_DIR} ${IPOPT_DIR}/build) 

# define external project
SET(CMAKE_LIST_CONTENT_IPOPT "
    	cmake_minimum_required(VERSION 2.8)

	include(ExternalProject)
    
	ExternalProject_Add( 1-Ipopt_external
			SOURCE_DIR ${IPOPT_DIR}	CONFIGURE_COMMAND ${IPOPT_DIR}/configure 
			--prefix=${IPOPT_DIR} --enable-static	coin_skip_warn_cxxflags=yes
			#to prevent possible error 'object name conflicts' when building on mingw 
      #+++NB actual error was more likely order of paths between msys/mingw and windows
			--disable-linear-solver-loader) 
	")

# save CMakeLists.txt
file(WRITE ${IPOPT_DIR}/CMakeLists.txt "${CMAKE_LIST_CONTENT_IPOPT}")
    
# configure (windows or linux/mac)
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows") 
  execute_process(COMMAND ${CMAKE_COMMAND} -G "MSYS Makefiles" .. WORKING_DIRECTORY ${IPOPT_DIR}/build)
else(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  execute_process(COMMAND ${CMAKE_COMMAND} ..	WORKING_DIRECTORY ${IPOPT_DIR}/build)
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows") 

# make & make install
execute_process(COMMAND ${CMAKE_COMMAND} --build . WORKING_DIRECTORY ${IPOPT_DIR}/build)

ENDIF(NOT EXISTS ${IPOPT_DIR}/lib)

