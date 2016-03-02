#####################################################
# Icestorm toolchain builder for linux_x86_64 archs #
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
ARCH=linux_x86_64

# -- Directory for compiling the tools
BUILD_DIR=build_$ARCH

# -- Icestorm directory
ICESTORM=icestorm
ICEPROG=iceprog
ICEPACK=icepack
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
                     xdot pkg-config python python3 libftdi-dev

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

# -- TEST the generated executable
bash $WORK/test/test_iceprog.sh iceprog

# -- Copy the executable to the bin dir
cp iceprog $INSTALL/bin

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
cp icepack $INSTALL/bin

# ----------- Compile Arachne-pnr ----------------------------------
cd $WORK/$UPSTREAM
git -C $ARACHNE pull || git clone --depth=1 $GIT_ARACHNE

cd $WORK/$BUILD_DIR
cp -r $WORK/$UPSTREAM/$ARACHNE .
cd $ARACHNE

# -- Apply the patches
cp $WORK/$DATA/Makefile.arachne $WORK/$BUILD_DIR/$ARACHNE/Makefile

# -- Copy the chipdb*.bin data files
mkdir -p $WORK/$BUILD_DIR/$NAME/share/$ARACHNE
cp -r $WORK/build-data/$ARACHNE/chip*.bin $WORK/$BUILD_DIR/$NAME/share/$ARACHNE

# -- Compile it
make

# -- Copy the executable to the bin dir
cp bin/arachne-pnr $INSTALL/bin

# ------------ Compile Yosys 0.6 --------------------------------
cd $WORK/$UPSTREAM
wget https://github.com/cliffordwolf/yosys/archive/yosys-0.6.tar.gz
tar vzxf yosys-0.6.tar.gz

cd $WORK/$BUILD_DIR
cp -r $WORK/$UPSTREAM/yosys-yosys-0.6 .
cd yosys-yosys-0.6

# -- Apply the patches
cp $WORK/$DATA/Makefile.yosys $WORK/$BUILD_DIR/yosys-yosys-0.6/Makefile



# ---------------------- Create the package --------------------------
cd $WORK/$BUILD_DIR
tar vzcf $TARBALL $NAME

# -- Move the package to the packages dir
mv $TARBALL $WORK/$PACK_DIR



# Install Arachne-PNR
#git -C arachne-pnr pull || git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
#cd arachne-pnr
#if [ "$1" == "clean" ]; then
#    make clean
#fi
#cp $WORK/packages/build_x86_64/Makefile.arachne Makefile
#make -j$(( $(nproc) -1))
#make install DESTDIR=$TCDIR PREFIX="" ICEBOX="$TCDIR/share/icebox"
#cd ..

# Install Yosys
#git -C yosys pull || git clone https://github.com/cliffordwolf/yosys.git yosys
#cd yosys
#if [ "$1" == "clean" ]; then
#    make clean
#fi

#cp $WORK/packages/build_x86_64/Makefile.yosys Makefile
#make -j$nproc$(( $(nproc) -1)) || exit 1
#make install DESTDIR=$TCDIR PREFIX=""
#cd ..

# Package tarball
#tar -czvf $TARBALL $NAME
