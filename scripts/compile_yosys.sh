# -- Compile Yosys script

REL=1 # 1: load from release tag. 0: load from source code

VER=0.8
YOSYS=yosys-yosys-$VER
TAR_YOSYS=yosys-$VER.tar.gz
REL_YOSYS=https://github.com/cliffordwolf/yosys/archive/$TAR_YOSYS
GIT_YOSYS=https://github.com/cliffordwolf/yosys.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

if [ $REL -eq 1 ]; then
  # -- Check and download the release
  test -e $TAR_YOSYS || wget $REL_YOSYS
  # -- Unpack the release
  tar zxf $TAR_YOSYS
else
  # -- Clone the sources from github
  git clone --depth=1 $GIT_YOSYS $YOSYS
  git -C $YOSYS pull
  echo ""
  git -C $YOSYS log -1
fi

# -- Copy the upstream sources into the build directory
rsync -a $YOSYS $BUILD_DIR --exclude .git

cd $BUILD_DIR/$YOSYS

# -- Compile it
EXE_O=

if [ $ARCH == "darwin" ]; then
  make config-clang
  gsed -i "s/-Wall -Wextra -ggdb/-w/;" Makefile
  make -j$J YOSYS_VER="$VER (Apio build)" \
            ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0
            ABCMKARGS="CC=\"$CC\" CXX=\"$CXX\" OPTFLAGS=\"-O\" \
                       ARCHFLAGS=\"$ABC_ARCHFLAGS\" ABC_USE_NO_READLINE=1"

elif [ ${ARCH:0:7} == "windows" ]; then

make config-gcc
  sed -i "s/-fPIC/-fpermissive/;" Makefile
  sed -i "s/-Wall -Wextra -ggdb/-w/;" Makefile
  sed -i "s/LD = gcc$/LD = $CC/;" Makefile
  sed -i "s/CXX = gcc$/CXX = $CC/;" Makefile
  sed -i "s/LDLIBS += -lrt/LDLIBS +=/;" Makefile
  sed -i "s/LDFLAGS += -rdynamic/LDFLAGS +=/;" Makefile
        # create dummy file to test output format for windows
        echo "int main(){}" >testgcc.c
        $CXX -o testgcc testgcc.c
        if [ -f testgcc.exe ]; then

            sed -i 's/EXE =/EXE =.exe/g' Makefile
            EXE_O=.exe
        fi



  make -j$J YOSYS_VER="$VER (Apio build)" CPPFLAGS="-DYOSYS_WIN32_UNIX_DIR" \
            LDLIBS="-static -lstdc++ -lm" \
            ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0 \
            ABCMKARGS="CC=\"$CC\" CXX=\"$CXX\" LIBS=\"-static -lm\" OPTFLAGS=\"-O\" \
                       ARCHFLAGS=\"$ABC_ARCHFLAGS\" ABC_USE_NO_READLINE=1 ABC_USE_NO_PTHREADS=1 ABC_USE_LIBSTDCXX=1"
else
  make config-gcc
  sed -i "s/-Wall -Wextra -ggdb/-w/;" Makefile
  sed -i "s/LD = gcc$/LD = $CC/;" Makefile
  sed -i "s/CXX = gcc$/CXX = $CC/;" Makefile
  sed -i "s/LDFLAGS += -rdynamic/LDFLAGS +=/;" Makefile
  make -j$J YOSYS_VER="$VER (Apio build)" \
            LDLIBS="-static -lstdc++ -lm" \
            ENABLE_TCL=0 ENABLE_PLUGINS=0 ENABLE_READLINE=0 ENABLE_COVER=0 \
            ABCMKARGS="CC=\"$CC\" CXX=\"$CXX\" LIBS=\"-static -lm -ldl -pthread\" OPTFLAGS=\"-O\" \
                       ARCHFLAGS=\"$ABC_ARCHFLAGS -Wno-unused-but-set-variable\" ABC_USE_NO_READLINE=1"
fi

if [ $ARCH != "darwin" ]; then
  # -- Test the generated executables
  test_bin yosys$EXE_O
  test_bin yosys-abc$EXE_O
  test_bin yosys-config
  test_bin yosys-filterlib$EXE_O
  test_bin yosys-smtbmc
fi

# -- Copy the executable files
cp yosys$EXE_O $PACKAGE_DIR/$NAME/bin/yosys$EXE
cp yosys-abc$EXE_O $PACKAGE_DIR/$NAME/bin/yosys-abc$EXE
cp yosys-config $PACKAGE_DIR/$NAME/bin/yosys-config
cp yosys-filterlib$EXE_O $PACKAGE_DIR/$NAME/bin/yosys-filterlib$EXE
cp yosys-smtbmc $PACKAGE_DIR/$NAME/bin/yosys-smtbmc$PY

# -- Copy the share folder to the package folder
mkdir -p $PACKAGE_DIR/$NAME/share/yosys
cp -r share/* $PACKAGE_DIR/$NAME/share/yosys
