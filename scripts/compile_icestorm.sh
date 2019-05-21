# -- Compile Icestorm script

ICESTORM=icestorm
COMMIT=5ab07ed32a768d484284f1d0e58f61c2ef9d398a
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $ICESTORM || git clone $GIT_ICESTORM $ICESTORM
git -C $ICESTORM pull
git -C $ICESTORM checkout $COMMIT
git -C $ICESTORM log -1

# -- Copy the upstream sources into the build directory
rsync -a $ICESTORM $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICESTORM

# -- Compile it
if [ $ARCH == "darwin" ]; then
  gsed -i "s/-ggdb //;" config.mk
  make -j$J CC="$CC" \
            SUBDIRS="iceprog"
  make -j$J CXX="$CXX" \
            SUBDIRS="icebox icepack icemulti icepll icetime icebram"
else
  sed -i "s/-ggdb //;" config.mk
  sed -i "s/\$^ \$(LDLIBS)/\$^ \$(LDLIBS) \$(LDUSBSTATIC)/g" iceprog/Makefile
  make -j$J CC="$CC" \
            SUBDIRS="iceprog" \
            LDFLAGS="-static -pthread -L$WORK_DIR/build-data/lib/$ARCH " \
	          LDUSBSTATIC="-lusb-1.0"\
            CFLAGS="-MD -O0 -Wall -std=c99 -I$WORK_DIR/build-data/include/libftdi1 -I$WORK_DIR/build-data/include/libusb-1.0"
  make -j$J CXX="$CXX" STATIC=1 \
            SUBDIRS="icebox icepack icemulti icepll icetime icebram"
fi

TOOLS="icepack iceprog icemulti icepll icetime icebram"

EXE_O=
if [ -f iceprog/iceprog.exe ]; then
  EXE_O=.exe
fi

# -- Test the generated executables
for dir in $TOOLS; do
  test_bin $dir/$dir$EXE_O
done

# -- Copy the executables to the bin dir
for dir in $TOOLS; do
  cp $dir/$dir$EXE_O $PACKAGE_DIR/$NAME/bin/$dir$EXE
done

# -- Copy the chipdb*.txt data files
mkdir -p $PACKAGE_DIR/$NAME/share/icebox
cp -r icebox/chipdb*.txt $PACKAGE_DIR/$NAME/share/icebox
