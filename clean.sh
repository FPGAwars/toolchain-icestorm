#!/bin/bash
##################################
#   Icestorm toolchain cleaner   #
##################################

# -- Target architectures
ARCHS=$1
TARGET_ARCHS="linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows darwin"

# -- Store current dir
WORK_DIR=$PWD
# -- Folder for building the source code
BUILDS_DIR=$WORK_DIR/_builds
# -- Folder for storing the generated packages
PACKAGES_DIR=$WORK_DIR/_packages

# -- Test script function
function test_bin {
  $WORK_DIR/test/test_bin.sh $1
  if [ $? != "0" ]; then
    exit 1
  fi
}

# -- Check ARCHS
if [ "$ARCHS" == "" ]; then
  echo ""
  echo "Usage:"
  echo "  bash clean.sh \"linux_x86_64 linux_armv7l\""
  echo ""
  echo "Target archs:"
  echo "  $TARGET_ARCHS"
fi

# -- Loop
for ARCH in $ARCHS
do

  if [[ ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
    echo ""
    echo ">>> WRONG ARCHITECTURE $ARCH"
    continue
  fi

  echo ""
  echo ">>> ARCHITECTURE $ARCH"

  # -- Directory for compiling the tools
  BUILD_DIR=$BUILDS_DIR/build_$ARCH

  # -- Directory for installation the target files
  PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

  # -- Remove the package dir
  rm -r -f $PACKAGE_DIR

  # -- Remove the build dir
  rm -r -f $BUILD_DIR

  echo ""
  echo ">> CLEAN"

done
