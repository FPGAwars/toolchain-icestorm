# -- Compile Arachne PnR script

ARACHNE=arachne-pnr
COMMIT=840bdfdeb38809f9f6af4d89dd7b22959b176fdd
GIT_ARACHNE=https://github.com/cseed/arachne-pnr.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $ARACHNE || git clone $GIT_ARACHNE $ARACHNE
git -C $ARACHNE pull
git -C $ARACHNE checkout $COMMIT
git -C $ARACHNE log -1

# -- Copy the upstream sources into the build directory
rsync -a $ARACHNE $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ARACHNE
EXE_O=
# -- Compile it
if [ $ARCH == "darwin" ]; then
  make -j$J CXX="$CXX" LIBS="-lm" ICEBOX="../icestorm/icebox"
else
    CROSSFLAGS=
    if [ $ARCH == "windows_amd64" ] || [ $ARCH == "windows_x86" ]; then
        # create dummy file to test output format for windows
        echo "int main(){}" >testgcc.c
        $CXX -o testgcc testgcc.c
        if [ -f testgcc.exe ]; then
            EXE_O=.exe
        fi
        sed -i "s/bin\/arachne-pnr\ -d\ /\.\/bin\/arachne-pnr\ -d\ /;" Makefile
        # grep -l "bin/arachne-pnr" Makefile | xargs sed -i 's/bin\/arachne-pnr\$(EXE)/bin\/arachne-pnr.exe/g'

	# In crosscompiling arachnenpr needs test with host compiled app
	CROSSFLAGS="HOST_CXX=\"clang++\""

    else
        sed -i "s/bin\/arachne-pnr\ -d\ /\.\/bin\/arachne-pnr\ -d\ /;" Makefile
    fi
    make -j$J $CROSSFLAGS CXX="$CXX" LIBS="-static -static-libstdc++ -static-libgcc -lm" ICEBOX="../icestorm/icebox"
fi


if [ $ARCH != "darwin" ]; then
   # -- Test the generated executables
  test -e share/$ARACHNE/chipdb-1k.bin || exit 1
  test -e share/$ARACHNE/chipdb-5k.bin || exit 1
  test -e share/$ARACHNE/chipdb-8k.bin || exit 1
  test -e share/$ARACHNE/chipdb-384.bin || exit 1
  test -e share/$ARACHNE/chipdb-lm4k.bin || exit 1
  test_bin bin/arachne-pnr$EXE_O
fi


# -- Copy the executable to the bin dir
cp bin/arachne-pnr$EXE_O $PACKAGE_DIR/$NAME/bin/arachne-pnr$EXE

# -- Copy the chipdb*.bin data files
mkdir -p $PACKAGE_DIR/$NAME/share/$ARACHNE
cp -r share/$ARACHNE/chipdb*.bin $PACKAGE_DIR/$NAME/share/$ARACHNE
