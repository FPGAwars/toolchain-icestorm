# -- Compile Icoprog for RPI2 script

ICOPROG=icoprog

J=$(($(nproc)-1))

cd $WORK_DIR/build-data

# -- Copy the upstream sources into the build directory
rsync -a $ICOPROG $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICOPROG

# -- Compile wiringPi
cd wiringPi
make -j$J CC=arm-linux-gnueabihf-gcc static
cd ..

# -- Compile icoprog
PWD=`pwd`
make -j$J PWD=$PWD

# -- Test the generated executables
test_bin icoprog

# -- Copy the executables to the bin dir
cp icoprog $PACKAGE_DIR/$NAME/bin
