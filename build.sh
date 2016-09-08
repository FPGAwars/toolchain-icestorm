#!/bin/bash
##################################
#   Icestorm toolchain builder   #
##################################

# Generate toolchain-icestorm-arch-ver.tar.gz from source code
# sources: http://www.clifford.at/icestorm/

VERSION=9

# -- Target architectures
ARCHS=( )
# ARCHS=( linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows )
# ARCHS=( darwin )

# -- Toolchain name
NAME=toolchain-icestorm

# -- Debug flags
COMPILE_ICESTORM=1
COMPILE_ARACHNE=1
COMPILE_YOSYS=1
COMPILE_YOSYS_ABC=1
COMPILE_ICOPROG=1
CREATE_PACKAGE=1

# -- Store current dir
WORK_DIR=$PWD
# -- Folder for building the source code
BUILDS_DIR=$WORK_DIR/_builds
# -- Folder for storing the generated packages
PACKAGES_DIR=$WORK_DIR/_packages
# --  Folder for storing the source code from github
UPSTREAM_DIR=$WORK_DIR/_upstream

# -- Create the build directory
mkdir -p $BUILDS_DIR
# -- Create the packages directory
mkdir -p $PACKAGES_DIR
# -- Create the upstream directory and enter into it
mkdir -p $UPSTREAM_DIR

# -- Test script function
function test_bin {
  $WORK_DIR/test/test_bin.sh $1
  if [ $? != "0" ]; then
    exit 1
  fi
}
# -- Print function
function print {
  echo ""
  echo $1
  echo ""
}

# -- Check ARCHS
if [ ${#ARCHS[@]} -eq 0 ]; then
  print "NOTE: add your architectures to the ARCHS variable in the build.sh script"
fi

# -- Loop
for ARCH in ${ARCHS[@]}
do

  echo ""
  echo ">>> ARCHITECTURE $ARCH"

  # -- Directory for compiling the tools
  BUILD_DIR=$BUILDS_DIR/build_$ARCH

  # -- Directory for installation the target files
  PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

  # --- Directory where the files for patching the upstream are located
  DATA=$WORK_DIR/build-data/$ARCH

  # -- Remove the build dir and the generated packages then exit
  if [ "$1" == "clean" ]; then

    # -- Remove the package dir
    rm -r -f $PACKAGE_DIR

    # -- Remove the build dir
    rm -r -f $BUILD_DIR

    print ">> CLEAN"
    continue
  fi

  # -- Install dependencies
  print ">> Install dependencies"
  . $WORK_DIR/install_dependencies.sh

  # -- Create the build dir
  mkdir -p $BUILD_DIR

  # -- Create the package folders
  mkdir -p $PACKAGE_DIR/$NAME/bin
  mkdir -p $PACKAGE_DIR/$NAME/share
  cp -r $WORK_DIR/build-data/examples $PACKAGE_DIR/$NAME

  # --------- Compile icestorm ---------------------------------------
  if [ $COMPILE_ICESTORM == "1" ]; then

    print ">> Compile icestorm"
    . $WORK_DIR/compile_icestorm.sh

  fi

  # --------- Compile arachne-pnr ------------------------------------
  if [ $COMPILE_ARACHNE == "1" ]; then

    print ">> Compile arachne-pnr"
    . $WORK_DIR/compile_arachnepnr.sh

  fi

  # --------- Compile yosys ------------------------------------------
  if [ $COMPILE_YOSYS == "1" ]; then

    print ">> Compile yosys"
    . $WORK_DIR/compile_yosys.sh

  fi

  # --------- Compile yosys-abc --------------------------------------
  if [ $COMPILE_YOSYS_ABC == "1" ]; then

    print ">> Compile yosys abc"
    . $WORK_DIR/compile_yosys_abc.sh

  fi

  # --------- Compile icoprog ----------------------------------------
  if [ $COMPILE_ICOPROG == "1" ]; then

    if [ $ARCH == "linux_armv7l" ]; then

      print ">> Compile icoprog RPI2"
      . $WORK_DIR/compile_icoprog.sh

    fi

  fi

  # --------- Create the package -------------------------------------
  if [ $CREATE_PACKAGE == "1" ]; then

    print ">> Create package"
    . $WORK_DIR/create_package.sh

  fi

done
