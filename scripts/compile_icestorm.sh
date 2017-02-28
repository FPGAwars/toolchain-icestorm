# -- Compile Icestorm script

ICESTORM=icestorm
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $ICESTORM || git clone --depth=1 $GIT_ICESTORM $ICESTORM
git -C $ICESTORM pull

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
  make -j$J CC="$CC" \
            SUBDIRS="iceprog" \
            LDFLAGS="-static -pthread -L$WORK_DIR/build-data/lib/$ARCH" \
            CFLAGS="-MD -O0 -Wall -std=c99 -I$WORK_DIR/build-data/include/libftdi1"
  make -j$J CXX="$CXX" STATIC=1 \
            SUBDIRS="icebox icepack icemulti icepll icetime icebram"
fi

TOOLS="icepack iceprog icemulti icepll icetime icebram"

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  for dir in $TOOLS; do
      test_bin $dir/$dir
  done
fi

# -- Copy the executables to the bin dir
for dir in $TOOLS; do
  cp $dir/$dir $PACKAGE_DIR/$NAME/bin/$dir$EXE
done

# -- Copy the chipdb*.txt data files
mkdir -p $PACKAGE_DIR/$NAME/share/icebox
cp -r icebox/chipdb*.txt $PACKAGE_DIR/$NAME/share/icebox
