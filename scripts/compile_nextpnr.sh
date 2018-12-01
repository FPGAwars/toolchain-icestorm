# -- Compile Arachne PnR script

NEXTPNR=nextpnr
COMMIT=dc549cd56bf1db4342a2bab1fb3fc04ca3a9ceea
GITNEXTPNR=https://github.com/YosysHQ/nextpnr

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $NEXTPNR || git clone $GITNEXTPNR $NEXTPNR
git -C $NEXTPNR pull
git -C $NEXTPNR checkout $COMMIT
git -C $NEXTPNR log -1

# -- Copy the upstream sources into the build directory
rsync -a $NEXTPNR $BUILD_DIR --exclude .git

cd $BUILD_DIR/$NEXTPNR

mkdir icebox
cp -v ../icestorm/icefuzz/*.txt icebox/
cp -v ../icestorm/icebox/*.txt icebox/

# -- Compile it
if [ $ARCH == "darwin" ]; then
  cmake -DARCH=ice40 -DICEBOX_ROOT="./icebox" .
  make -j$J CXX="$CXX" LIBS="-lm"
else
  cmake -DARCH=ice40 -DICEBOX_ROOT="./icebox" .
  make -j$J CXX="$CXX" LIBS="-static -static-libstdc++ -static-libgcc -lm"
fi || exit 1

# -- Copy the executable to the bin dir
cp bin/nextpnr-ice40 $PACKAGE_DIR/$NAME/bin/arachne-pnr$EXE

# -- Copy the chipdb*.bin data files
mkdir -p $PACKAGE_DIR/$NAME/share/$NEXTPNR
cp -r share/$NEXTPNR/chipdb*.bin $PACKAGE_DIR/$NAME/share/$NEXTPNR
