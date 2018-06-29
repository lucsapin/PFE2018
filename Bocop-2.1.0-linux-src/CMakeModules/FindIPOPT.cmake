#FindLIBIPOPT.cmake

set(CMAKE_FIND_LIBRARY_PREFIXES "lib")

#+++still useful ?
if(${IPOPT_VERSION} MATCHES "3.10.2")
	set(LIB_COINBLAS_VERSION "1.2.1" CACHE STRING "libcoinblas version")
	set(LIB_COINLAPACK_VERSION "1.3.2" CACHE STRING "libcoinlapack version")
	set(LIB_COINMUMPS_VERSION "1.4.2" CACHE STRING "libcoinmumps version")
	set(LIB_IPOPT_VERSION "1.8.2" CACHE STRING "libipopt version")
elseif(${IPOPT_VERSION} MATCHES "3.11.4")
	set(LIB_COINBLAS_VERSION "1.3.6" CACHE STRING "libcoinblas version")
	set(LIB_COINLAPACK_VERSION "1.4.6" CACHE STRING "libcoinlapack version")
	set(LIB_COINMUMPS_VERSION "1.4.9" CACHE STRING "libcoinmumps version")
	set(LIB_IPOPT_VERSION "1.9.4" CACHE STRING "libipopt version")
elseif(${IPOPT_VERSION} MATCHES "3.11.8")
	set(LIB_COINBLAS_VERSION "1.3.11" CACHE STRING "libcoinblas version")
	set(LIB_COINLAPACK_VERSION "1.4.11" CACHE STRING "libcoinlapack version")
	set(LIB_COINMUMPS_VERSION "1.4.13" CACHE STRING "libcoinmumps version")
	set(LIB_COINMETIS_VERSION "1.2.10" CACHE STRING "libcoinmetis version")
	set(LIB_IPOPT_VERSION "1.9.8" CACHE STRING "libipopt version")
elseif(${IPOPT_VERSION} MATCHES "3.12.3")
	set(LIB_COINBLAS_VERSION "1.4.2" CACHE STRING "libcoinblas version")
	set(LIB_COINLAPACK_VERSION "1.5.2" CACHE STRING "libcoinlapack version")
	set(LIB_COINMUMPS_VERSION "1.5.2" CACHE STRING "libcoinmumps version")
	set(LIB_COINMETIS_VERSION "1.3.2" CACHE STRING "libcoinmetis version")
	set(LIB_IPOPT_VERSION "1.10.3" CACHE STRING "libipopt version")
endif(${IPOPT_VERSION} MATCHES "3.10.2")

# We search for the dynamic libraries first
# Mac OS
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".dylib"  ".a" )
# Windows 
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows") 
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".dll.a" ".so") 
# Linux
else() 
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a" )
endif()

# If there are no symbolic links in the third parties, we create them.
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
	# Symlinks for blas
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.so.${LIB_COINBLAS_VERSION})
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.so.${LIB_COINBLAS_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.so.1)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.so.${LIB_COINBLAS_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.so)
	endif()

	# Symlinks for lapack
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.so.${LIB_COINLAPACK_VERSION})
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.so.${LIB_COINLAPACK_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.so.1)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.so.${LIB_COINLAPACK_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.so)
	endif()

	# Symlinks for mumps
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.so.${LIB_COINMUMPS_VERSION})
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.so.${LIB_COINMUMPS_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.so.1)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.so.${LIB_COINMUMPS_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.so)
	endif()
	
	# Symlinks for metis
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.so.${LIB_COINMETIS_VERSION})
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.so.${LIB_COINMETIS_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.so.1)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.so.${LIB_COINMETIS_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.so)
	endif()

	# Symlinks for ipopt
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.so.${LIB_IPOPT_VERSION})
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.so.${LIB_IPOPT_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.so.1)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.so.${LIB_IPOPT_VERSION} ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.so)
	endif()

endif() # Symlinks on linux 

# On Mac OS we have to change the install_name and create the symbolic links
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	# Symlinks for blas
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.${LIB_COINBLAS_VERSION}.dylib)
	execute_process(COMMAND install_name_tool -id ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.${LIB_COINBLAS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.${LIB_COINBLAS_VERSION}.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.${LIB_COINBLAS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.1.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.${LIB_COINBLAS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinblas.dylib)
	endif()

	# Symlinks for lapack
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.${LIB_COINLAPACK_VERSION}.dylib)
	execute_process(COMMAND install_name_tool -id ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.${LIB_COINLAPACK_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.${LIB_COINLAPACK_VERSION}.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.${LIB_COINLAPACK_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.1.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.${LIB_COINLAPACK_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinlapack.dylib)
	endif()

	# Symlinks for mumps
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.${LIB_COINMUMPS_VERSION}.dylib)
	execute_process(COMMAND install_name_tool -id ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.${LIB_COINMUMPS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.${LIB_COINMUMPS_VERSION}.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.${LIB_COINMUMPS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.1.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.${LIB_COINMUMPS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmumps.dylib)
	endif()
	
	# Symlinks for metis
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.${LIB_COINMETIS_VERSION}.dylib)
	execute_process(COMMAND install_name_tool -id ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.${LIB_COINMETIS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.${LIB_COINMETIS_VERSION}.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.${LIB_COINMETIS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.1.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.${LIB_COINMETIS_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.dylib)
	endif()

	# Symlinks for ipopt
	if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.${LIB_IPOPT_VERSION}.dylib)
	execute_process(COMMAND install_name_tool -id ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.${LIB_IPOPT_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.${LIB_IPOPT_VERSION}.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.${LIB_IPOPT_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.1.dylib)
	execute_process(COMMAND ln -fs ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.${LIB_IPOPT_VERSION}.dylib ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libipopt.dylib)
	endif()
endif()



find_path(IPOPT_INCLUDE_DIR IpoptConfig.h
	  HINTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/include/coin
          PATH_SUFFIXES ipopt 
)

find_library(BLAS_LIBRARY coinblas
             HINTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib)
         
find_library(LAPACK_LIBRARY coinlapack
             HINTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib)

find_library(MUMPS_LIBRARY coinmumps
             HINTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib)
             
if(EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.so.${LIB_COINMETIS_VERSION} 
   OR EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.a
   OR EXISTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib/libcoinmetis.${LIB_COINMETIS_VERSION}.dylib)
find_library(METIS_LIBRARY coinmetis
             HINTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib)
endif()

find_library(IPOPT_LIBRARY ipopt
             HINTS ${PROJECT_SOURCE_DIR}/ThirdParty/Ipopt-${IPOPT_VERSION}/lib)

# The dependencies have to be in descending order
if(${IPOPT_LIBRARY} MATCHES "ThirdParty")
	set(IPOPT_LIBRARIES
  	${IPOPT_LIBRARY}
  	${MUMPS_LIBRARY} 
  	${LAPACK_LIBRARY} 
  	${METIS_LIBRARY}
  	${BLAS_LIBRARY}
	)
	
	set(IPOPT_INCLUDE_DIRS 
  	${IPOPT_INCLUDE_DIR} 
  	${IPOPT_INCLUDE_DIR}/ThirdParty
	)
  set(IPOPT_FOUND true)
else()
  set(IPOPT_FOUND false)
endif(${IPOPT_LIBRARY} MATCHES "ThirdParty")
	
