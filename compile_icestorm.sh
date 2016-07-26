cd $UPSTREAM_DIR

# -- Clone the toolchain from the github
git -C $ICESTORM pull || git clone --depth=1 $GIT_ICESTORM $ICESTORM

# -- Copy the upstream sources into the build directory
rsync -a $ICESTORM $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICESTORM

# -- Apply the patches
cp $DATA/Makefile.iceprog $BUILD_DIR/$ICESTORM/iceprog/Makefile
# ...

# -- Compile it
make -j$(( $(nproc) -1)) STATIC=1 -C iceprog
make -j$(( $(nproc) -1)) STATIC=1 -C icepack
make -j$(( $(nproc) -1)) STATIC=1 -C icetime

# -- Test the generated executables
test_bin iceprog/iceprog
test_bin icepack/icepack
test_bin icetime/icetime

# -- Copy the executables to the bin dir
cp iceprog/iceprog $PACKAGE_DIR/$NAME/bin
cp icepack/icepack $PACKAGE_DIR/$NAME/bin
cp icetime/icetime $PACKAGE_DIR/$NAME/bin
