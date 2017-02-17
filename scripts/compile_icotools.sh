# -- Compile Icoprog for RPI2 script

WIRINGPI=wirintPi
GIT_WIRINGPI=git://git.drogon.net/wiringPi

ICOTOOLS=icotools
GIT_ICOTOOLS=https://github.com/cliffordwolf/icotools.git

J=$(($(nproc)-1))

## WiringPi

cd $UPSTREAM_DIR

# -- Clone the sources from github
git -C $WIRINGPI pull || git clone --depth=1 $GIT_WIRINGPI $WIRINGPI

# -- Copy the upstream sources into the build directory
rsync -a $WIRINGPI $BUILD_DIR --exclude .git

cd $BUILD_DIR/$WIRINGPI

# -- Compile it
cd wiringPi
make -j$J CC=arm-linux-gnueabihf-gcc static

## Icoprog

cd $UPSTREAM_DIR

# -- Clone the sources from github
git -C $ICOTOOLS pull || git clone --depth=1 $GIT_ICOTOOLS $ICOTOOLS

# -- Copy the upstream sources into the build directory
rsync -a $ICOTOOLS $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICOTOOLS

# -- Apply the patches
cp $DATA/Makefile.icoprog $BUILD_DIR/$ICOTOOLS/icoprog/Makefile

# -- Compile it
make -j$J WD=$BUILD_DIR/$WIRINGPI/wiringPi/ -C icoprog

# -- Test the generated executables
test_bin icoprog/icoprog

# -- Copy the executables to the bin dir
cp icoprog/icoprog $PACKAGE_DIR/$NAME/bin
