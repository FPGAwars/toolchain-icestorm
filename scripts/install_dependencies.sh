# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev # <- v1
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev:i386
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
fi

if [ $ARCH == "windows" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev git-core \
                          mingw-w64 mingw-w64-tools wine
fi

if [ $ARCH == "darwin" ]; then
  brew install bison flex gawk libffi git mercurial graphviz \
               pkg-config python3 libusb libftdi gnu-sed wget
fi
