# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev # <- v1
                          gcc-5 g++-5
  sudo apt-get autoremove -y
  sudo ln -sf /usr/bin/gcc-5 /usr/bin/gcc
  sudo ln -sf /usr/bin/g++-5 /usr/bin/g++
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-5-multilib g++-5-multilib
  sudo apt-get autoremove -y
  sudo ln -sf /usr/bin/gcc-5 /usr/bin/gcc
  sudo ln -sf /usr/bin/g++-5 /usr/bin/g++
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
                          binfmt-support qemu-user-static
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
                          binfmt-support qemu-user-static
  sudo apt-get autoremove -y
fi

if [ $ARCH == "windows_x86" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-5-mingw-w64 gc++-5-mingw-w64 \
                          #mingw-w64 mingw-w64-tools \
                          wine
  sudo apt-get autoremove -y
  sudo ln -sf /usr/bin/i386-mingw32-gcc-5 /usr/bin/i386-mingw32-gcc
  sudo ln -sf /usr/bin/i386-mingw32-g++-5 /usr/bin/i386-mingw32-g++
fi

if [ $ARCH == "windows_amd64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libftdi1-dev \
                          gcc-5-mingw-w64 gc++-5-mingw-w64 \
                          #mingw-w64 mingw-w64-tools \
                          wine
  sudo apt-get autoremove -y
  sudo ln -sf /usr/bin/x86-w64-mingw32-gcc-5 /usr/bin/x86-w64-mingw32-gcc
  sudo ln -sf /usr/bin/x86-w64-mingw32-g++-5 /usr/bin/x86-w64-mingw32-g++
fi

if [ $ARCH == "darwin" ]; then
  DEPS="bison flex gawk libffi git mercurial graphviz \
        pkg-config python3 libusb libftdi gnu-sed wget"
  brew update
  brew install --force $DEPS
  brew unlink $DEPS && brew link --force $DEPS
fi
