# -- Compile Arachne PnR script

ARACHNE=arachne-pnr
GIT_ARACHNE=https://github.com/cseed/arachne-pnr.git

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
git -C $ARACHNE pull || git clone --depth=1 $GIT_ARACHNE $ARACHNE

# -- Copy the upstream sources into the build directory
rsync -a $ARACHNE $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ARACHNE

# -- Compile it
make -j$J LIBS="-static" ICEBOX="../icestorm/icebox"

if [ $ARCH != "darwin" ]; then
  # -- Test the generated executables
  test_bin bin/arachne-pnr$EXT
fi

# -- Copy the executable to the bin dir
cp bin/arachne-pnr$EXT $PACKAGE_DIR/$NAME/bin

# -- Copy the chipdb*.bin data files
mkdir -p $PACKAGE_DIR/$NAME/share/chipdb
cp -r share/$ARACHNE/chip*.bin $PACKAGE_DIR/$NAME/share/chipdb
