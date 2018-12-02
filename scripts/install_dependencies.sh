# Install dependencies script

BOOST="libboost-dev libboost-filesystem-dev libboost-thread-dev libboost-program-options-dev libboost-python-dev libboost-dev"

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3.6-dev libftdi1-dev \
                          gcc-5 g++-5 $BOOST qt5-default
  sudo apt-get autoremove -y
  sudo update-alternatives \
    --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-5
  gcc --version
  g++ --version
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3.6-dev libftdi1-dev \
                          gcc-5-multilib g++-5-multilib $BOOST qt5-default
  sudo apt-get autoremove -y
  sudo update-alternatives \
    --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-5
  gcc --version
  g++ --version
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3.6-dev libftdi1-dev \
                          gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
                          binfmt-support qemu-user-static $BOOST qt5-default
  sudo apt-get autoremove -y
  arm-linux-gnueabihf-gcc --version
  arm-linux-gnueabihf-g++ --version
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3.6-dev libftdi1-dev \
                          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
                          binfmt-support qemu-user-static $BOOST qt5-default
  sudo apt-get autoremove -y
  aarch64-linux-gnu-gcc --version
  aarch64-linux-gnu-g++ --version
fi

if [ $ARCH == "windows_x86" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3.6-dev libftdi1-dev \
                          gcc-5-mingw-w64 gc++-5-mingw-w64 wine $BOOST qt5-default
                          #mingw-w64 mingw-w64-tools
  sudo apt-get autoremove -y
  sudo update-alternatives \
    --install /usr/bin/i686-w64-mingw32-gcc i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-5 60 \
    --slave /usr/bin/i686-w64-mingw32-g++ i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-5
  i686-w64-mingw32-gcc --version
  i686-w64-mingw32-g++ --version
fi

if [ $ARCH == "windows_amd64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3.6-dev libftdi1-dev \
                          gcc-5-mingw-w64 gc++-5-mingw-w64 wine $BOOST qt5-default
                          #mingw-w64 mingw-w64-tools
  sudo apt-get autoremove -y
  sudo update-alternatives \
    --install /usr/bin/x86_64-w64-mingw32-gcc x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-5 60 \
    --slave /usr/bin/x86_64-w64-mingw32-g++ x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-5
  x86_64-w64-mingw32-gcc --version
  x86_64-w64-mingw32-g++ --version
fi

if [ $ARCH == "darwin" ]; then
  DEPS="bison flex gawk libffi git mercurial graphviz \
        pkg-config python3 libusb libftdi gnu-sed wget boost boost-python3 qt5"
  brew update
  brew install --force $DEPS
  brew upgrade python
  brew unlink $DEPS && brew link --force $DEPS
fi
