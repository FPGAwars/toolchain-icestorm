# -- Compile Yosys script

YOSYS=yosys-yosys-0.6
REL_YOSYS=https://github.com/cliffordwolf/yosys/archive/yosys-0.6.tar.gz

EXT=""
if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

cd $UPSTREAM_DIR

# -- Check and download the release
test -e yosys-0.6.tar.gz || wget $REL_YOSYS

# -- Unpack the release
tar vzxf yosys-0.6.tar.gz

# -- Copy the upstream sources into the build directory
rsync -a $YOSYS $BUILD_DIR --exclude .git

cd $BUILD_DIR/$YOSYS

# -- Apply the patches
cp $DATA/Makefile.yosys $BUILD_DIR/$YOSYS/Makefile
cp $WORK_DIR/build-data/yosys/version*.cc $BUILD_DIR/$YOSYS/kernel

# -- Compile it
make -j$(( $(nproc) -1))

# -- Test the generated executables
test_bin yosys$EXT

# -- Copy the executable file
cp yosys$EXT $PACKAGE_DIR/$NAME/bin

# -- Copy the share folder to the package folder
mkdir -p $PACKAGE_DIR/$NAME/share
cp -r $WORK_DIR/build-data/yosys/share/* $PACKAGE_DIR/$NAME/share
