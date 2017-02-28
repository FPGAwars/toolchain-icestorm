#!/bin/bash
##################################
#   Icestorm toolchain builder   #
##################################

# Generate toolchain-icestorm-arch-ver.tar.gz from source code
# sources: http://www.clifford.at/icestorm/

VERSION=1.10.0

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows_x86 windows_amd64 darwin"

# -- Toolchain name
NAME=toolchain-icestorm

# -- Debug flags
INSTALL_DEPS=1
COMPILE_ICESTORM=1
COMPILE_ARACHNE=1
COMPILE_YOSYS=1
COMPILE_ICOTOOLS=1
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

# -- Check ARCH
if [[ $# > 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# < 1 ]]; then
  echo ""
  echo "Usage: bash build.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  exit 1
fi

echo ""
echo ">>> ARCHITECTURE \"$ARCH\""

# -- Directory for compiling the tools
BUILD_DIR=$BUILDS_DIR/build_$ARCH

# -- Directory for installation the target files
PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

# --------- Instal dependencies ------------------------------------
if [ $INSTALL_DEPS == "1" ]; then

  print ">> Install dependencies"
  . $WORK_DIR/scripts/install_dependencies.sh

fi

# -- Create the build dir
mkdir -p $BUILD_DIR

# -- Create the package folders
mkdir -p $PACKAGE_DIR/$NAME/bin
mkdir -p $PACKAGE_DIR/$NAME/share

# --------- Compile icestorm ---------------------------------------
if [ $COMPILE_ICESTORM == "1" ]; then

  print ">> Compile icestorm"
  . $WORK_DIR/scripts/compile_icestorm.sh

fi

# --------- Compile arachne-pnr ------------------------------------
if [ $COMPILE_ARACHNE == "1" ]; then

  print ">> Compile arachne-pnr"
  . $WORK_DIR/scripts/compile_arachnepnr.sh

fi

# --------- Compile yosys ------------------------------------------
if [ $COMPILE_YOSYS == "1" ]; then

  print ">> Compile yosys"
  . $WORK_DIR/scripts/compile_yosys.sh

fi

# --------- Compile icotools ----------------------------------------
if [ $COMPILE_ICOTOOLS == "1" ]; then

  if [ $ARCH == "linux_armv7l" ]; then

    print ">> Compile icotools for RPI"
    . $WORK_DIR/scripts/compile_icotools.sh

  fi

fi

# --------- Create the package -------------------------------------
if [ $CREATE_PACKAGE == "1" ]; then

  print ">> Create package"
  . $WORK_DIR/scripts/create_package.sh

fi
