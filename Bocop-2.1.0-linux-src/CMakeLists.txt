# This code is published under the Eclipse Public License
# Authors: Daphne Giorgi, Pierre Martinon, Olivier Tissot, Jinyan Liu
# Inria Saclay and Cmap Ecole Polytechnique
# 2014-2017

cmake_minimum_required(VERSION 2.6)

#######################################
# 						BOCOP
#######################################

# the compiler must be changed before the project command (+++is this still needed ?)
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_C_COMPILER /usr/bin/cc)
  set(CMAKE_CXX_COMPILER /usr/bin/c++)
endif()

# Project name
project(BOCOP)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules")

# default: assume that cmake is called from build/ folder in problem folder
# override with -DPROBLEM_DIR=[path_to_problem] in cmake call (e.g. when building from GUI)
set(PROBLEM_DIR "${CMAKE_BINARY_DIR}/.." CACHE PATH "Path to current problem") #CACHE seems needed to build from GUI
#+++this seems to work on linux, needs to be tested on other platforms 
message(STATUS "Problem path: " ${PROBLEM_DIR})
# NB. set(PROBLEM_DIR ".." CACHE PATH "problem path") does not work since ".." is taken from CMakeLists.txt path -_-
#set(PROBLEM_DIR "$ENV{PWD}/.." CACHE PATH "Path to current problem") works only on linux

#######################################
# THIRDPARTIES
#######################################

# NLP solver
# Ipopt is always 3.12.8 except for old Mac (not tested)
set(IPOPT_VERSION "3.12.8" CACHE STRING "Ipopt version")
include(BuildIPOPT)
find_package(IPOPT) #option REQUIRED does not seem to work, hence manual error 
#find_package(IPOPTsys) for already installed ipopt
if (IPOPT_FOUND)
  include_directories(${IPOPT_INCLUDE_DIRS})
  message(STATUS "Using IPOPT " ${IPOPT_VERSION} " at " ${IPOPT_LIBRARY})
else (IPOPT_FOUND)
  message(FATAL_ERROR "IPOPT " ${IPOPT_VERSION}" LIBRARY NOT FOUND.BUILD TERMINATED")
endif (IPOPT_FOUND)

# Auomatic Differentiation: Adol-C/Colpack or CppAD
option(USE_CPPAD "Use CppAD instead of Adol-C/Colpack for Automatic Differentiation" OFF)

if (USE_CPPAD)
	
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -fpermissive") #for windows build in some cases
  set(CPPAD_SOURCE_DIR ${BOCOP_SOURCE_DIR}/ThirdParty/cppad)
  set(CPPAD_INCLUDE_DIRS ${CPPAD_SOURCE_DIR}/include)
  message(STATUS "Using CPPAD at " ${CPPAD_SOURCE_DIR})
  include_directories(${CPPAD_INCLUDE_DIRS})
  add_definitions(-DUSE_CPPAD)

else (USE_CPPAD)

# ADOL-C: 2.5.0 if compiler does not support c++11, 2.6.3 otherwise.
IF (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

  # MAC  
  exec_program(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
  string(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
  message(STATUS "DARWIN_VERSION=${DARWIN_VERSION}")
	IF (DARWIN_VERSION GREATER 12)
	# +++ try to update to 2.6.3 / 1.0.10
           set(COLPACK_VERSION "1.0.10" CACHE STRING "ColPack version")
           set(ADOLC_VERSION "2.6.3" CACHE STRING "ADOL-C version")
	   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -std=c++11")
	ELSE()
		 # Old Mac: thirdparties not updated, build not tested ...
	   message("Warning: build not tested, please condider updating your OS.")
	   set(COLPACK_VERSION "1.0.9" CACHE STRING "ColPack version")
	   set(ADOLC_VERSION "2.4.1" CACHE STRING "ADOL-C version")
	   set(IPOPT_VERSION "3.10.2" CACHE STRING "Ipopt version")
	ENDIF(DARWIN_VERSION GREATER 12)

ELSE()

  # LINUX / WINDOWS (MINGW)
	IF (CMAKE_COMPILER_IS_GNUCC)
	   # Check for c++11 support in gcc (required for ADOLC > 2.5.0)
	   execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpversion	OUTPUT_VARIABLE GCC_VERSION)
	   IF (GCC_VERSION VERSION_GREATER 4.7 OR GCC_VERSION VERSION_EQUAL 4.7)
	      # c++11 is supported
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")           
			if(WIN32)
				set(ADOLC_VERSION "2.5.2" CACHE STRING "ADOL-C version")
				set(COLPACK_VERSION "1.0.10" CACHE STRING "ColPack version")
			else()
			    set(ADOLC_VERSION "2.6.3" CACHE STRING "ADOL-C version")
				set(COLPACK_VERSION "1.0.11" CACHE STRING "ColPack version")
			endif(WIN32)
			
	   ELSE ()
	   	  # c++11 is NOT supported
	     set(COLPACK_VERSION "1.0.9" CACHE STRING "ColPack version")
	     set(ADOLC_VERSION "2.5.0" CACHE STRING "ADOL-C version")
	   ENDIF (GCC_VERSION VERSION_GREATER 4.7 OR GCC_VERSION VERSION_EQUAL 4.7)
	   
	ELSE()
	   # play safe and assume that compiler does not support c++11 ...
	   set(COLPACK_VERSION "1.0.9" CACHE STRING "ColPack version")
	   set(ADOLC_VERSION "2.5.0" CACHE STRING "ADOL-C version")
	ENDIF (CMAKE_COMPILER_IS_GNUCC)
	
ENDIF (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

# build/check Adolc and Colpack
include(BuildADOLC)
find_package(ADOLC) #option REQUIRED does not seem to work, hence manual error 
if (ADOLC_FOUND)
  include_directories(${ADOLC_INCLUDE_DIRS})
  message(STATUS "Using ADOLC " ${ADOLC_VERSION} " at " ${ADOLC_LIBRARY})
else ()
  message(FATAL_ERROR "ADOLC " ${ADOLC_VERSION} " LIBRARY NOT FOUND. BUILD TERMINATED")
endif ()

endif(USE_CPPAD)

#######################################
# C++ FLAGS
#######################################

# NB. debug / release flags are *added* to base flags CMAKE_CXX_FLAGS according to CMAKE_BUILD_TYPE !
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wconversion -Wdouble-promotion -pedantic -pg") #default -g for gcc/linux
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -w") #default -O3 -DNDEBUG for gcc/linux

if(${CMAKE_BUILD_TYPE} MATCHES "Release")
  message(STATUS "flags (release): " ${CMAKE_CXX_FLAGS_RELEASE})
elseif(${CMAKE_BUILD_TYPE} MATCHES "Debug")
  message(STATUS "flags (debug): " ${CMAKE_CXX_FLAGS_DEBUG})
else()
  message(STATUS "flags (base): " ${CMAKE_CXX_FLAGS})
endif()

# Note: on Ubuntu 13.10 we have to add a compilation flag for the linker
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")


#######################################
# PATHS AND INCLUDES
#######################################

# Set some paths
add_definitions(-DPATH_DISC=\"${BOCOP_SOURCE_DIR}/core/disc/\") #+++obsolete
#add_definitions(-DPROBLEM_DIR=\"${PROBLEM_DIR}/\")  #+++obsolete
set(LIBRARY_OUTPUT_PATH ${PROBLEM_DIR}/build/lib)
set(SOURCES_DIR ${BOCOP_SOURCE_DIR}/core/sources)
set(HEADERS_DIR ${BOCOP_SOURCE_DIR}/core/headers)
set(EXECUTABLE_OUTPUT_PATH ${PROBLEM_DIR})

# Include headers and sources directories (order matters ! check vs hjb)
include_directories(${PROBLEM_DIR}) # for measure, pre and post-processing
include_directories(${BOCOP_SOURCE_DIR}/core) # for boost include that are written as "boost/..." -_-
include_directories(${BOCOP_SOURCE_DIR}/core/headers)
include_directories(${BOCOP_SOURCE_DIR}/core/sources)
include_directories(${BOCOP_SOURCE_DIR}/core/sources/disc) #for discTools
include_directories(${BOCOP_SOURCE_DIR}/core/sources/nlp) #for errortoobservation
include_directories(${BOCOP_SOURCE_DIR}/core/sources/optionalfunctions) #dependencies

# Set the headers (in order to see them on qtcreator) 
set(BOCOPCORE_HDRS 
			 ${HEADERS_DIR}/BocopDefinition.hpp
		   ${HEADERS_DIR}/BocopOptimize.hpp
		   ${HEADERS_DIR}/BocopInterpolation.hpp
		   ${HEADERS_DIR}/BocopProblem.hpp
		   ${HEADERS_DIR}/common.hpp
		   ${HEADERS_DIR}/functions.hpp	   
		   ${HEADERS_DIR}/GenerationVariable.hpp
		   ${HEADERS_DIR}/parametrizedcontrol.hpp
		   ${HEADERS_DIR}/postProcessing.hpp
		   ${HEADERS_DIR}/preProcessing.hpp
		   ${HEADERS_DIR}/publicTools.hpp
       ${HEADERS_DIR}/StartingPoint.hpp
		   ${HEADERS_DIR}/tools.hpp)       
				
# Set the sources 
set(BOCOPCORE_SRCS_DISC 
      ${SOURCES_DIR}/disc/computeDynConstraints.tpp
			${SOURCES_DIR}/disc/discTools.tpp)
#			${SOURCES_DIR}/disc/parametrizedcontrol.tpp) #+++obsolete

set(BOCOPCORE_SRCS_INTERPOLATION 
      ${SOURCES_DIR}/interpolation/BocopInterpolation.cpp
			${SOURCES_DIR}/interpolation/BocopLinearInterpolation.cpp
			${SOURCES_DIR}/interpolation/BocopSplinesInterpolation.cpp)

set(BOCOPCORE_SRCS_IO	
      ${SOURCES_DIR}/IO/readDefinition.cpp
			${SOURCES_DIR}/IO/writeDefinition.cpp
			${SOURCES_DIR}/IO/writeSolution.cpp)
						
set(BOCOPCORE_SRCS_IPOPT 
	     ${SOURCES_DIR}/ipopt/BocopDefinition.cpp
			 ${SOURCES_DIR}/ipopt/BocopOptimizeBatch.cpp
			 ${SOURCES_DIR}/ipopt/BocopOptimize.cpp
			 ${SOURCES_DIR}/ipopt/BocopOptimizeSingle.cpp)

set(BOCOPCORE_SRCS_NLP	
      ${SOURCES_DIR}/nlp/BocopProblem.cpp
			${SOURCES_DIR}/nlp/errorToObservation.tpp
			${SOURCES_DIR}/nlp/evalNLPBounds.cpp 
			${SOURCES_DIR}/nlp/evalNLPFunctions.tpp 
			${SOURCES_DIR}/nlp/generateTapes.cpp						
			${SOURCES_DIR}/nlp/overloaded_from_nlp.cpp
			${SOURCES_DIR}/nlp/publicTools.cpp
#			${SOURCES_DIR}/nlp/publicTools.tpp		#+++obsolete
			${SOURCES_DIR}/nlp/tools.cpp)
			
set(BOCOPCORE_SRCS_STARTINGPOINT 
      ${SOURCES_DIR}/startingpoint/GenerationVariable.cpp
			${SOURCES_DIR}/startingpoint/StartFromInitFile.cpp
			${SOURCES_DIR}/startingpoint/StartFromPreviousSolution.cpp			
			${SOURCES_DIR}/startingpoint/StartingPoint.cpp)

set(BOCOPCORE_SRCS_PROBLEM 
      ${PROBLEM_DIR}/boundarycond.tpp
			${PROBLEM_DIR}/criterion.tpp
			${PROBLEM_DIR}/dynamics.tpp
			${PROBLEM_DIR}/pathcond.tpp)				

	
# Set optional sources
if(EXISTS ${PROBLEM_DIR}/dependencies.hpp)
  set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${PROBLEM_DIR}/dependencies.hpp)
else()
  set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${SOURCES_DIR}/optionalfunctions/dependencies.hpp)   
endif(EXISTS ${PROBLEM_DIR}/dependencies.hpp)
if(EXISTS ${PROBLEM_DIR}/dependencies.tpp)
  set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${PROBLEM_DIR}/dependencies.tpp)
else()
  set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${SOURCES_DIR}/optionalfunctions/dependencies.tpp)   
endif(EXISTS ${PROBLEM_DIR}/dependencies.tpp)
if(EXISTS ${PROBLEM_DIR}/dependencies.cpp)
  set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${PROBLEM_DIR}/dependencies.cpp)
else()
  set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${SOURCES_DIR}/optionalfunctions/dependencies.cpp)   
endif(EXISTS ${PROBLEM_DIR}/dependencies.cpp)
if(EXISTS ${PROBLEM_DIR}/measure.tpp)
	set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${PROBLEM_DIR}/measure.tpp)
else()
	set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${SOURCES_DIR}/optionalfunctions/measure.tpp)
endif(EXISTS ${PROBLEM_DIR}/measure.tpp)
if(EXISTS ${PROBLEM_DIR}/preProcessing.cpp)
	set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${HEADERS_DIR}/preProcessing.hpp ${PROBLEM_DIR}/preProcessing.cpp)
else()
	set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${HEADERS_DIR}/preProcessing.hpp ${SOURCES_DIR}/optionalfunctions/preProcessing.cpp)
endif(EXISTS ${PROBLEM_DIR}/preProcessing.cpp)
if(EXISTS ${PROBLEM_DIR}/postProcessing.cpp)
	set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${HEADERS_DIR}/postProcessing.hpp ${PROBLEM_DIR}/postProcessing.cpp)
else()
	set(BOCOPCORE_SRCS_EXTERNAL ${BOCOPCORE_SRCS_EXTERNAL} ${HEADERS_DIR}/postProcessing.hpp ${SOURCES_DIR}/optionalfunctions/postProcessing.cpp)
endif(EXISTS ${PROBLEM_DIR}/postProcessing.cpp)

# All sources
set(BOCOPCORE_SRCS 	
      ${BOCOPCORE_HDRS}
			${BOCOPCORE_SRCS_IO}
			${BOCOPCORE_SRCS_IPOPT}
			${BOCOPCORE_SRCS_NLP}
			${BOCOPCORE_SRCS_DISC}
			${BOCOPCORE_SRCS_STARTINGPOINT}
			${BOCOPCORE_SRCS_INTERPOLATION}
			${BOCOPCORE_SRCS_EXTERNAL}
			${BOCOPCORE_SRCS_PROBLEM})


# Build the library of the core (static by default, override with -DBUILD_LIBS_SHARED=ON)
option(BUILD_LIBS_SHARED "Build the libraries shared." OFF)
IF(BUILD_LIBS_SHARED)
  set(LIBS_LIBRARY_TYPE SHARED)
ELSE(BUILD_LIBS_SHARED)
  set(LIBS_LIBRARY_TYPE STATIC)
ENDIF(BUILD_LIBS_SHARED)
add_library(bocopcore ${LIBS_LIBRARY_TYPE} ${BOCOPCORE_SRCS})

# set library dependencies according to OS +++nb careful with mingw64 !
if(WIN32)
  target_link_libraries(bocopcore ${IPOPT_LIBRARIES} ${ADOLC_LIBRARIES} gfortran pthread m mingw32)
else()
  target_link_libraries(bocopcore ${IPOPT_LIBRARIES} ${ADOLC_LIBRARIES} m pthread dl)
endif()

# Build the executable
add_executable(bocop core/main.cpp)
target_link_libraries(bocop	bocopcore)

# Package building with CPACK (default OFF)
#+++ Cant put it at top, Cpack needs Cmake definitions. And function.hpp depends on dependencies.cpp
OPTION(BUILD_PACKAGE "Build package." OFF)
# Fix for too long filename on windows
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(CPACK_PACKAGE_DIRECTORY "C:/")
endif()

#+++ most of these options are not supported anymore. Update this ...
set(PACKAGE_TYPE SRC CACHE STRING "Package type (SRC, SRC32, SRC64, WIN, MACLION, MACMAVERICKS, LINUX32, or LINUX64)")
IF(BUILD_PACKAGE)
    include(BocopCPack)
ENDIF(BUILD_PACKAGE)