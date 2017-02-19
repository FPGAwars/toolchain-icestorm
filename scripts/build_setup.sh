# Build setup script

EXT=""

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

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi

if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi
