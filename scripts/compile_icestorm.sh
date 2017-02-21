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
make -j3 SUBDIRS="iceprog" CC="$CC" \
         LDLIBS="-lftdi1 -lusb-1.0 -lm -pthread" \
         LDFLAGS="-static -L $WORK_DIR/build-data/lib/$ARCH"
make -j3 SUBDIRS="icebox icepack icemulti icepll icetime icebram" \
         CXX="$CXX" STATIC=1

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
cp -r icebox/chip*.txt $PACKAGE_DIR/$NAME/share/icebox
