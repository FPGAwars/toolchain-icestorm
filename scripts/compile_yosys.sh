# -- Compile Yosys script

VER=0.7
YOSYS=yosys-yosys-$VER
TAR_YOSYS=yosys-$VER.tar.gz
REL_YOSYS=https://github.com/cliffordwolf/yosys/archive/$TAR_YOSYS

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Check and download the release
test -e $TAR_YOSYS || wget $REL_YOSYS

# -- Unpack the release
tar zxf $TAR_YOSYS

# -- Copy the upstream sources into the build directory
rsync -a $YOSYS $BUILD_DIR --exclude .git

cd $BUILD_DIR/$YOSYS

# -- Compile it

if [ $ARCH == "darwin" ]; then
  make config-clang
  gsed -i "s/-ggdb //;" Makefile
  make -j$J YOSYS_VER="0.7 (Apio build)" \
            ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0
            ABCMKARGS="CC=\"$CC\" CXX=\"$CXX\" OPTFLAGS=\"-O\" \
                       ARCHFLAGS=\"$ABC_ARCHFLAGS\" ABC_USE_NO_READLINE=1"

elif [ ${ARCH:0:7} == "windows" ]; then
  make config-gcc
  sed -i "s/-fPIC //;" Makefile
  sed -i "s/-ggdb //;" Makefile
  sed -i "s/LD = gcc$/LD = $CC/;" Makefile
  sed -i "s/CXX = gcc$/CXX = $CC/;" Makefile
  sed -i "s/LDLIBS += -lrt/LDLIBS +=/;" Makefile
  sed -i "s/LDFLAGS += -rdynamic/LDFLAGS +=/;" Makefile
  make -j$J YOSYS_VER="0.7 (Apio build)" \
            LDLIBS="-static -lstdc++ -lm" \
            ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0 \
            ABCMKARGS="CC=\"$CC\" CXX=\"$CXX\" LIBS=\"-static -lm\" OPTFLAGS=\"-O\" \
                       ARCHFLAGS=\"$ABC_ARCHFLAGS -Wno-unused-but-set-variable\" ABC_USE_NO_READLINE=1 ABC_USE_NO_PTHREADS=1"
else
  make config-gcc
  sed -i "s/-ggdb //;" Makefile
  sed -i "s/LD = gcc$/LD = $CC/;" Makefile
  sed -i "s/CXX = gcc$/CXX = $CC/;" Makefile
  sed -i "s/LDLIBS += -lrt/LDLIBS +=/;" Makefile
  sed -i "s/LDFLAGS += -rdynamic/LDFLAGS +=/;" Makefile
  make -j$J YOSYS_VER="0.7 (Apio build)" \
            LDLIBS="-static -lstdc++ -lm" \
            ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0 \
            ABCMKARGS="CC=\"$CC\" CXX=\"$CXX\" LIBS=\"-static -lm -ldl -pthread\" OPTFLAGS=\"-O\" \
                       ARCHFLAGS=\"$ABC_ARCHFLAGS -Wno-unused-but-set-variable\" ABC_USE_NO_READLINE=1"
fi

if [ $ARCH != "darwin" ]; then
  # -- Test the generated executables
  test_bin yosys
  test_bin yosys-abc
fi

# -- Copy the executable file
cp yosys $PACKAGE_DIR/$NAME/bin/yosys$EXE
cp yosys-abc $PACKAGE_DIR/$NAME/bin/yosys-abc$EXE

# -- Copy the share folder to the package folder
if [ ${ARCH:0:7} == "windows" ]; then
  cp -r share/* $PACKAGE_DIR/$NAME/share
else
  mkdir -p $PACKAGE_DIR/$NAME/share/yosys
  cp -r share/* $PACKAGE_DIR/$NAME/share/yosys
fi
