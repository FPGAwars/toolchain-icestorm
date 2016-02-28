#####################################################
# Icestorm toolchain builder for Windows 32 bits    #
# It should be execute on a Linux x86_64 machine    #
#####################################################

# Generate toolchain-icestorm.tar.gz from source code
# sources: http://www.clifford.at/icestorm/
# This tarball can be unpacked in ~/.platformio/packages

# -- Upstream folder. This is where all the toolchain is stored
# -- from the github
UPSTREAM=upstream

# -- Git url were to retieve the upstream sources
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git

# -- Folder for storing the generated packages
PACK_DIR=packages

# -- Target architecture
ARCH=windows_i386

# -- Directory for compiling the tools
BUILD_DIR=build_$ARCH

# -- Icestorm directory
ICESTORM=icestorm

# -- Iceprog directory
ICEPROG=iceprog

# --- Directory where the files for patching the upstream are located
DATA=build-data/$ARCH

# -- toolchain name
NAME=toolchain-icestorm

# -- Directory for installation the target files
INSTALL=$PWD/$BUILD_DIR/$NAME

VERSION=6
PACKNAME=$NAME-$ARCH-$VERSION
TARBALL=$PACKNAME.tar.gz
ZIPBALL=$PACKNAME.zip

# Store current dir
WORK=$PWD

# -- TARGET: CLEAN. Remove the build dir and the generated packages
# --  then exit
if [ "$1" == "clean" ]; then
  echo "-----> CLEAN"

  # -- Remove the final package
  rm -r -f $PACK_DIR/$NAME-$ARCH-*

  # -- Remove the build dir
  rm -r -f $BUILD_DIR
  exit
fi

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev git-core \
                     mingw-w64 mingw-w64-tools zip

# Create the upstream directory and enter into it
mkdir -p $UPSTREAM
cd $WORK/$UPSTREAM

# -------- Clone the toolchain from the github
# -- Icetools
git -C $ICESTORM pull || git clone $GIT_ICESTORM $ICESTORM

# -------- Create the packages directory
cd $WORK
mkdir -p $PACK_DIR

# -------- Create the build dir and enter into it
mkdir -p $BUILD_DIR
cd $WORK/$BUILD_DIR

# --- Create the target folder
mkdir -p $NAME
mkdir -p $NAME/bin

# -- Create the example folder
mkdir -p $NAME/examples

# -- Copy all the examples into it
cp -r $WORK/build-data/examples/* $WORK/$BUILD_DIR/$NAME/examples

# ---- Copy the upstream sources into the build directory
cp -r $WORK/$UPSTREAM/$ICESTORM/$ICEPROG .

# --------- Compile the iceprog
cd $WORK/$BUILD_DIR/$ICEPROG

# -- Apply the patches
cp $WORK/$DATA/Makefile.iceprog $WORK/$BUILD_DIR/$ICEPROG/Makefile

# -- Compile it!
make

# -- Copy the executable to the bin dir
cp iceprog.exe $INSTALL/bin

# -- Create the package
cd $WORK/$BUILD_DIR
#tar vzcf $TARBALL $NAME
zip -r $ZIPBALL $NAME

# -- Move the package to the packages dir
mv $ZIPBALL $WORK/$PACK_DIR
