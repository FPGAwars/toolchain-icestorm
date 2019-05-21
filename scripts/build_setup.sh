# Build setup script

if [ $ARCH == "linux_x86_64" ]; then
  CC="gcc"
  CXX="g++"
  ABC_ARCHFLAGS="-DLIN64 -DSIZEOF_VOID_P=8 -DSIZEOF_LONG=8 -DSIZEOF_INT=4"
fi

if [ $ARCH == "linux_i686" ]; then
  CC="gcc -m32"
  CXX="g++ -m32"
  ABC_ARCHFLAGS="-DLIN -DSIZEOF_VOID_P=4 -DSIZEOF_LONG=4 -DSIZEOF_INT=4"
fi

if [ $ARCH == "linux_armv7l" ]; then
  CC="arm-linux-gnueabihf-gcc"
  CXX="arm-linux-gnueabihf-g++"
  ABC_ARCHFLAGS="-DLIN -DSIZEOF_VOID_P=4 -DSIZEOF_LONG=4 -DSIZEOF_INT=4"
fi

if [ $ARCH == "linux_aarch64" ]; then
  CC="aarch64-linux-gnu-gcc"
  CXX="aarch64-linux-gnu-g++"
  ABC_ARCHFLAGS="-DLIN64 -DSIZEOF_VOID_P=8 -DSIZEOF_LONG=8 -DSIZEOF_INT=4"
fi

if [ $ARCH == "windows_x86" ]; then
  PY=".py"
  EXE=".exe"
  CC="i686-w64-mingw32-gcc"
  CXX="i686-w64-mingw32-g++"
  ABC_ARCHFLAGS="-DSIZEOF_VOID_P=4 -DSIZEOF_LONG=4 -DSIZEOF_INT=4 -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -D_POSIX_SOURCE -fpermissive -w"
fi

if [ $ARCH == "windows_amd64" ]; then
  PY=".py"
  EXE=".exe"
  CC="x86_64-w64-mingw32-gcc"
  CXX="x86_64-w64-mingw32-g++"
  ABC_ARCHFLAGS="-DSIZEOF_VOID_P=8 -DSIZEOF_LONG=8 -DSIZEOF_INT=4 -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -D_POSIX_SOURCE -fpermissive -w"
fi

if [ $ARCH == "darwin" ]; then
  CC="clang"
  CXX="clang++"
  ABC_ARCHFLAGS="-DLIN64 -DSIZEOF_VOID_P=8 -DSIZEOF_LONG=8 -DSIZEOF_INT=4"
  J=`sysctl -n hw.ncpu`
else
  J=`nproc`
fi

# Support for 1cpu machines
if [ $J -gt 1 ]; then
  J=$(($J-1))
fi
