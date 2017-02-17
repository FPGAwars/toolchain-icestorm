# Build setup script

EXT=""

if [ $ARCH == "linux_x86_64" ]; then
  CC="gcc"
  CXX="g++"
fi

if [ $ARCH == "linux_i686" ]; then
  CC="gcc -m32"
  CXX="g++ -m32"
fi

if [ $ARCH == "linux_armv7l" ]; then
  echo ""
fi

if [ $ARCH == "linux_aarch64" ]; then
  echo ""
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi

if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi
