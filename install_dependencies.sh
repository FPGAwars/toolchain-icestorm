# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential clang bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz   \
                          xdot pkg-config python python3 libftdi1-dev # <- v1
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential clang bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz   \
                          xdot pkg-config python python3 gcc-multilib \
                          g++-multilib libudev-dev:i386 libftdi1-dev:i386 \
                          libftdi1:i386
fi

if [ $ARCH == "windows" ]; then
  sudo apt-get install -y build-essential clang bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz   \
                          xdot pkg-config python python3 libftdi1-dev git-core \
                          mingw-w64 mingw-w64-tools zip
fi
