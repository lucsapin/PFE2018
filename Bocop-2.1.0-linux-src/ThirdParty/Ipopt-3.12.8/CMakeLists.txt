
    	cmake_minimum_required(VERSION 2.8)

	include(ExternalProject)
    
	ExternalProject_Add( 1-Ipopt_external
			SOURCE_DIR /home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/Ipopt-3.12.8	CONFIGURE_COMMAND /home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/Ipopt-3.12.8/configure 
			--prefix=/home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/Ipopt-3.12.8 --enable-static	coin_skip_warn_cxxflags=yes
			#to prevent possible error 'object name conflicts' when building on mingw 
      #+++NB actual error was more likely order of paths between msys/mingw and windows
			--disable-linear-solver-loader) 
	