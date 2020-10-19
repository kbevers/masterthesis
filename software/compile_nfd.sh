#!/bin/sh
#
# Compiles NFD from root of FAST-directory
#

COMP=gfortran

# COMPILE
find ./pltlib -name '*.f' -exec $COMP -c {} \; 
find ./fd -name '*.f' -exec $COMP -c {} \; 
$COMP -o nfd main.o model.o time.o findiff.o findiff2d.o stencils.o stencils2d.o misc.o plt.o blkdat.o nopltlib.o

# copy binary to working directory
mv nfd bin/
