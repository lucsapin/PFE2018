
 	cmake_minimum_required(VERSION 2.8)
	include(ExternalProject)  
	ExternalProject_Add( 3-Adolc_external
			SOURCE_DIR /home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/ADOL-C-2.6.3 CONFIGURE_COMMAND /home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/ADOL-C-2.6.3/configure 
			--prefix=/home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/ADOL-C-2.6.3 --enable-sparse --with-colpack=/home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/ADOL-C-2.6.3/ThirdParty/ColPack 
			--libdir=/home/lsapin/Documents/n7/PFE/PFE2018/Bocop-2.1.0-linux-src/ThirdParty/ADOL-C-2.6.3/lib	 --with-cxxflags='-std=c++11' )
	