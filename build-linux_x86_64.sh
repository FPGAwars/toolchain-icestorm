#####################################################
# Icestorm toolchain builder for linux_x86_64 archs #
# It should be execute on a Linux x86_64 machine    #
#####################################################

# Generate toolchain-icestorm.tar.gz from source code
# sources: http://www.clifford.at/icestorm/
# This tarball can be unpacked in ~/.platformio/packages

#---- DEBUG
COMPILE_ICESTORM=1
COMPILE_ARACHNE=1
COMPILE_YOSYS=1
COMPILE_YOSYS_ABC=1
CREATE_PACKAGE=1

# -- Upstream folder. This is where all the toolchain is stored
# -- from the github
UPSTREAM=upstream

# -- Git url were to retieve the upstream sources
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git
GIT_ARACHNE=https://github.com/cseed/arachne-pnr.git
REL_YOSYS=https://github.com/cliffordwolf/yosys/archive/yosys-0.6.tar.gz

# -- Folder for storing the generated packages
PACK_DIR=packages

# -- Target architecture
ARCH=linux_x86_64

# -- Directory for compiling the tools
BUILD_DIR=build_$ARCH

# -- Icestorm directory
ICESTORM=icestorm
ARACHNE=arachne-pnr

# --- Directory where the files for patching the upstream are located
DATA=build-data/$ARCH

# -- toolchain name
NAME=toolchain-icestorm

# -- Directory for installation the target files
INSTALL=$PWD/$PACK_DIR/$NAME

VERSION=8
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
                     xdot pkg-config python python3 libftdi1-dev # <- version 1!

# Create the upstream directory and enter into it
mkdir -p $UPSTREAM

# Create the packages directory
mkdir -p $WORK/$PACK_DIR

# Create the build dir
mkdir -p $WORK/$BUILD_DIR


# --------- Compile icestorm ---------------------------------------
if [ $COMPILE_ICESTORM == "1" ]; then

    cd $WORK/$UPSTREAM
    # -------- Clone the toolchain from the github
    git -C $ICESTORM pull || git clone --depth=1 $GIT_ICESTORM $ICESTORM

    # ---- Copy the upstream sources into the build directory
    cp -r $WORK/$UPSTREAM/$ICESTORM $WORK/$BUILD_DIR

    cd $WORK/$BUILD_DIR/$ICESTORM

    # -- Compile it
    make -j$(( $(nproc) -1)) STATIC=1

    # -- TEST the generated executables
    bash $WORK/test/test_bin.sh iceprog/iceprog
    bash $WORK/test/test_bin.sh icepack/icepack
    bash $WORK/test/test_bin.sh icetime/icetime

    # -- Install in install dir
    make install PREFIX=$INSTALL

fi

# ----------- Compile Arachne-pnr ----------------------------------
if [ $COMPILE_ARACHNE == "1" ]; then

    cd $WORK/$UPSTREAM
    git -C $ARACHNE pull || git clone --depth=1 $GIT_ARACHNE $ARACHNE

    cp -r $WORK/$UPSTREAM/$ARACHNE $WORK/$BUILD_DIR
    cd $WORK/$BUILD_DIR/$ARACHNE

    # -- Apply the patches
    cp $WORK/$DATA/Makefile.arachne $WORK/$BUILD_DIR/$ARACHNE/Makefile

    # -- Copy the chipdb*.bin data files
    mkdir -p $WORK/$BUILD_DIR/$NAME/share/$ARACHNE
    cp -r $INSTALL/share/icebox/chip*.bin $WORK/$BUILD_DIR/$NAME/share/$ARACHNE

    # -- Compile it
    make -j$(( $(nproc) -1))

    # -- Copy the executable to the bin dir
    cp bin/arachne-pnr $INSTALL/bin

fi

# ------------ Compile Yosys 0.6 --------------------------------
if [ $COMPILE_YOSYS == "1" ]; then

    cd $WORK/$UPSTREAM
    test -e yosys-0.6.tar.gz || wget $REL_YOSYS
    tar vzxf yosys-0.6.tar.gz

    cd $WORK/$BUILD_DIR
    cp -r $WORK/$UPSTREAM/yosys-yosys-0.6 .
    cd yosys-yosys-0.6

    # -- Apply the patches
    cp $WORK/$DATA/Makefile.yosys $WORK/$BUILD_DIR/yosys-yosys-0.6/Makefile
    cp $WORK/build-data/yosys/version*.cc $WORK/$BUILD_DIR/yosys-yosys-0.6/kernel

    # -- Compile it
    make -j$(( $(nproc) -1))

    # -- Copy the share folder to the install folder
    mkdir -p $INSTALL/share/
    mkdir -p $INSTALL/share/yosys
    cp -r $WORK/build-data/yosys/share/* $INSTALL/share/yosys

    # -- Copy the executable files
    cp yosys $INSTALL/bin

fi

# ----------------- Compile yosys-abc --------------------------------
if [ $COMPILE_YOSYS_ABC == "1" ]; then

    echo "-------------> BUILDING YOSYS-ABS:"
    cd $WORK/$UPSTREAM
    test -d abc || hg clone https://bitbucket.org/alanmi/abc abc

    cd $WORK/$BUILD_DIR
    cp -r $WORK/$UPSTREAM/abc .
    cd abc

    # -- Apply the patches
    cp $WORK/$DATA/Makefile.yosys-abc $WORK/$BUILD_DIR/abc/Makefile

    # -- Compile it
    make -j$(( $(nproc) -1))

    cp yosys-abc $INSTALL/bin

fi

# ---------------------- Create the package --------------------------
if [ $CREATE_PACKAGE == "1" ]; then

    cd $WORK/$PACK_DIR
    tar vzcf $TARBALL $NAME

fi
