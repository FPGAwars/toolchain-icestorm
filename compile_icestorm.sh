# -- Compile Icestorm script

ICESTORM=icestorm
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git

EXT=""
if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi

cd $UPSTREAM_DIR

# -- Clone the sources from github
git -C $ICESTORM pull || git clone --depth=1 $GIT_ICESTORM $ICESTORM

# -- Copy the upstream sources into the build directory
rsync -a $ICESTORM $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICESTORM

# -- Apply the patches
cp $DATA/Makefile.iceprog $BUILD_DIR/$ICESTORM/iceprog/Makefile

# -- Compile it
make -j$J STATIC=1 -C iceprog
make -j$J STATIC=1 -C icepack
make -j$J STATIC=1 -C icetime
make -j$J STATIC=1 -C icepll
make -j$J STATIC=1 -C icebram

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin iceprog/iceprog$EXT
  test_bin icepack/icepack$EXT
  test_bin icetime/icetime$EXT
  test_bin icepll/icepll$EXT
  test_bin icebram/icebram$EXT
fi

# -- Copy the executables to the bin dir
cp iceprog/iceprog$EXT $PACKAGE_DIR/$NAME/bin
cp icepack/icepack$EXT $PACKAGE_DIR/$NAME/bin
cp icetime/icetime$EXT $PACKAGE_DIR/$NAME/bin
cp icepll/icepll$EXT $PACKAGE_DIR/$NAME/bin
cp icebram/icebram$EXT $PACKAGE_DIR/$NAME/bin
