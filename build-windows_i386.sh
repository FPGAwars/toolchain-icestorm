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
GIT_ARACHNE=https://github.com/cseed/arachne-pnr.git

# -- Folder for storing the generated packages
PACK_DIR=packages

# -- Target architecture
ARCH=windows_i386

# -- Directory for compiling the tools
BUILD_DIR=build_$ARCH

# -- Icestorm directory
ICESTORM=icestorm
ICEPACK=icepack
ICEPROG=iceprog
ARACHNE=arachne-pnr

# --- Directory where the files for patching the upstream are located
DATA=build-data/$ARCH

# -- toolchain name
NAME=toolchain-icestorm

# -- Directory for installation the target files
INSTALL=$PWD/$BUILD_DIR/$NAME

VERSION=7
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
mkdir -p $NAME/share

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

# ---------------- Compile the icepack
cd $WORK/$BUILD_DIR

# -- Copy the sources into the build directory
cp -r $WORK/$UPSTREAM/$ICESTORM/$ICEPACK .
cd $ICEPACK

# -- Apply the patches
cp $WORK/$DATA/Makefile.icepack $WORK/$BUILD_DIR/$ICEPACK/Makefile

# -- Compile it
make

# -- Copy the executable to the bin dir
cp icepack.exe $INSTALL/bin

# ----------- Compile Arachne-pnr ----------------------------------
cd $WORK/$UPSTREAM
git -C $ARACHNE pull || git clone --depth=1 $GIT_ARACHNE

cd $WORK/$BUILD_DIR
cp -r $WORK/$UPSTREAM/$ARACHNE .
cd $ARACHNE

# -- Apply the patches
cp $WORK/$DATA/Makefile.arachne $WORK/$BUILD_DIR/$ARACHNE/Makefile

cp -r $WORK/$DATA/arachne.patch/* $WORK/$BUILD_DIR/$ARACHNE

# -- Copy the chipdb*.bin data files
cp -r $WORK/build-data/$ARACHNE $WORK/$BUILD_DIR/$NAME/share

# -- Compile it
make

# -- Copy the executable to the bin dir
cp bin/arachne-pnr.exe $INSTALL/bin




# -- Create the package
cd $WORK/$BUILD_DIR
#tar vzcf $TARBALL $NAME
zip -r $ZIPBALL $NAME

# -- Move the package to the packages dir
mv $ZIPBALL $WORK/$PACK_DIR
