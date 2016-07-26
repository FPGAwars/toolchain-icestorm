# -- Compile Icestorm script

ICESTORM=icestorm
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git

EXT=""
if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

cd $UPSTREAM_DIR

# -- Clone the sources from github
git -C $ICESTORM pull || git clone --depth=1 $GIT_ICESTORM $ICESTORM

# -- Copy the upstream sources into the build directory
rsync -a $ICESTORM $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICESTORM

# -- Apply the patches
cp $DATA/Makefile.iceprog $BUILD_DIR/$ICESTORM/iceprog/Makefile
cp $DATA/Makefile.icepack $BUILD_DIR/$ICESTORM/icepack/Makefile
# cp $DATA/Makefile.icetime $BUILD_DIR/$ICESTORM/icetime/Makefile

# -- Compile it
make -j$(( $(nproc) -1)) STATIC=1 -C iceprog
make -j$(( $(nproc) -1)) STATIC=1 -C icepack
# make -j$(( $(nproc) -1)) STATIC=1 -C icetime

# -- Test the generated executables
test_bin iceprog/iceprog$EXT
test_bin icepack/icepack$EXT
# test_bin icetime/icetime$EXT

# -- Copy the executables to the bin dir
cp iceprog/iceprog$EXT $PACKAGE_DIR/$NAME/bin
cp icepack/icepack$EXT $PACKAGE_DIR/$NAME/bin
# cp icetime/icetime$EXT $PACKAGE_DIR/$NAME/bin
