# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev # <- v1
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev:i386 \
                          gcc-multilib g++-multilib
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
                          binfmt-support qemu-user-static
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
                          binfmt-support qemu-user-static
fi

if [ $ARCH == "windows_x86" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          mingw-w64 wine
fi

if [ $ARCH == "windows_amd64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          mingw-w64 wine
fi

if [ $ARCH == "darwin" ]; then
  DEPS="bison flex gawk libffi git mercurial graphviz \
        pkg-config python3 libusb libftdi gnu-sed wget"
  brew update
  brew install --force $DEPS
  brew unlink $DEPS && brew link --force $DEPS
fi
