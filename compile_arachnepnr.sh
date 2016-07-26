# -- Compile Arachne PnR script

ARACHNE=arachne-pnr
GIT_ARACHNE=https://github.com/cseed/arachne-pnr.git

EXT=""
if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

cd $UPSTREAM

# -- Clone the sources from github
git -C $ARACHNE pull || git clone --depth=1 $GIT_ARACHNE $ARACHNE

# -- Copy the upstream sources into the build directory
rsync -a $ARACHNE $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ARACHNE

# -- Apply the patches
cp $DATA/Makefile.arachne $BUILD_DIR/$ARACHNE/Makefile

# -- Compile it
make -j$(( $(nproc) -1))

# -- Test the generated executables
test_bin bin/arachne-pnr$EXT

# -- Copy the executable to the bin dir
cp bin/arachne-pnr$EXT $PACKAGE_DIR/$NAME/bin/arachne-pnr

# -- Copy the chipdb*.bin data files
mkdir -p $PACKAGE_DIR/$NAME/share/$ARACHNE
cp -r $WORK_DIR/build-data/$ARACHNE/chip*.bin $PACKAGE_DIR/$NAME/share/$ARACHNE
