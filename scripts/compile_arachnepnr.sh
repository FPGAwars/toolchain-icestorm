# -- Compile Arachne PnR script

ARACHNE=arachne-pnr
GIT_ARACHNE=https://github.com/cseed/arachne-pnr.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $ARACHNE || git clone --depth=1 $GIT_ARACHNE $ARACHNE
git -C $ARACHNE pull

# -- Copy the upstream sources into the build directory
rsync -a $ARACHNE $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ARACHNE

# -- Compile it
sed -i "s/bin\/arachne-pnr\ -d\ /\.\/bin\/arachne-pnr\ -d\ /;" Makefile
make -j$J CXX="$CXX" LIBS="-static" ICEBOX="../icestorm/icebox"

if [ $ARCH != "darwin" ]; then
  # -- Test the generated executables
  test_bin bin/arachne-pnr
fi

# -- Copy the executable to the bin dir
cp bin/arachne-pnr $PACKAGE_DIR/$NAME/bin/arachne-pnr$EXE

# -- Copy the chipdb*.bin data files
if [ $ARCH == "windows" ]; then
  cp -r share/$ARACHNE/chip*.bin $PACKAGE_DIR/$NAME/bin
else
  mkdir -p $PACKAGE_DIR/$NAME/share/$ARACHNE
  cp -r share/$ARACHNE/chip*.bin $PACKAGE_DIR/$NAME/share/$ARACHNE
fi
