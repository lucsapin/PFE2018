#!/bin/bash

## This is a shell script to automate the build process for Bocop
OS=`uname -s`
if ! [ -d build ]
then
  mkdir build
fi
cd build

# the cmake commands expects the path to bocop package as last argument:
# the ../../.. below works for instance if your problems are in <bocop>/examples/yourproblem
# please adjust this path if needed (you can use an environment variable BOCOP_PATH to set this globally)

# an optional argument is the path to your problem:  -DPROBLEM_DIR=<yourproblem>
# (this script is supposed to be executed in <yourproblem>/build so this path would be ..)

# build type can be Release or Debug, this will change the build flags

if [[ "$OS" == 'Linux' ]] || [[ "$OS" == 'Darwin' ]] ; then
    cmake -DCMAKE_BUILD_TYPE=Release ../../..
    #cmake -DCMAKE_BUILD_TYPE=Release $BOCOP_PATH
else
    cmake -G "MSYS Makefiles" -DPROBLEM_DIR=.. ../../..
    #cmake -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release $BOCOP_PATH
fi
make -j
cd -
