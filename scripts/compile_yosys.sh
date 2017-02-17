# -- Compile Yosys script

VER=0.7
YOSYS=yosys-yosys-$VER
TAR_YOSYS=yosys-$VER.tar.gz
REL_YOSYS=https://github.com/cliffordwolf/yosys/archive/$TAR_YOSYS

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

# -- Check and download the release
test -e $TAR_YOSYS || wget $REL_YOSYS

# -- Unpack the release
tar vzxf $TAR_YOSYS

# -- Copy the upstream sources into the build directory
rsync -a $YOSYS $BUILD_DIR --exclude .git

cd $BUILD_DIR/$YOSYS

# -- Compile it
make config-gcc
make -j$J ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0 \
          LDLIBS="-static -lstdc++ -lm" \
          ABCMKARGS="LIBS=\"-static -lm -ldl -lrt -pthread\" ABC_USE_NO_READLINE=1 CC=\"gcc\" CXX=\"gcc\"" \
          YOSYS_VER_STR="Yosys 0.7 (Apio build)"

if [ $ARCH != "darwin" ]; then
  # -- Test the generated executables
  test_bin yosys$EXT
  test_bin yosys-abc$EXT
fi

# -- Copy the executable file
cp yosys$EXT $PACKAGE_DIR/$NAME/bin
cp yosys-abc$EXT $PACKAGE_DIR/$NAME/bin

# -- Copy the share folder to the package folder
if [ $ARCH == "windows" ]; then
  cp -r share/* $PACKAGE_DIR/$NAME/share
else
  mkdir -p $PACKAGE_DIR/$NAME/share/yosys
  cp -r share/* $PACKAGE_DIR/$NAME/share/yosys
fi
