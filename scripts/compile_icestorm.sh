# -- Compile Icestorm script

ICESTORM=icestorm
GIT_ICESTORM=https://github.com/cliffordwolf/icestorm.git

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
git -C $ICESTORM pull || git clone --depth=1 $GIT_ICESTORM $ICESTORM

# -- Copy the upstream sources into the build directory
rsync -a $ICESTORM $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICESTORM

TOOLS="icepack iceprog icemulti icepll icetime icebram"

# -- Compile it
make -j3 SUBDIRS="iceprog" LDLIBS="-lftdi1 -lusb-1.0 -lm -lpthread" \
         LDFLAGS="-static -L $WORK_DIR/build-data/linux_x86_64/lib"
make -j3 SUBDIRS="icepack icemulti icepll icetime icebram" STATIC=1 \

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  for dir in $TOOLS; do
      test_bin $dir/$dir$EXT
  done
fi

# -- Copy the executables to the bin dir
for dir in $TOOLS; do
    cp $dir/$dir$EXT $PACKAGE_DIR/$NAME/bin
done

# -- Copy the chipdb*.bin data files
mkdir -p $PACKAGE_DIR/$NAME/share/chipdb
cp -r $WORK_DIR/build-data/chipdb/chip*.bin $PACKAGE_DIR/$NAME/share/chipdb
