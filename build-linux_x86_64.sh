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

# -- Folder for storing the generated packages
PACK_DIR=packages

# -- Target architecture
ARCH=linux_x86_64

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

# Store current dir
WORK=$PWD

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

# ---------------------- Create the package


cd $WORK/$BUILD_DIR
tar vzcf $TARBALL $NAME

# -- Move the package to the packages dir
mv $TARBALL $WORK/$PACK_DIR

#cp $WORK/packages/build_x86_64/Makefile.icetools Makefile
#cp $WORK/packages/build_x86_64/Makefile.icepack icepack/Makefile
#cp $WORK/packages/build_x86_64/Makefile.iceprog iceprog/Makefile
#cp $WORK/packages/build_x86_64/Makefile.icetime icetime/Makefile
#make -j$(( $(nproc) -1))
#make install DESTDIR=$TCDIR PREFIX=""

#cd ..

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
