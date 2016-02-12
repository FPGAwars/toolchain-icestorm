##############################
# Icestorm toolchain builder #
##############################

# Generate toolchain-icestorm.tar.gz from source code
# sources: http://www.clifford.at/icestorm/
# This tarball can be unpacked in ~/.platformio/packages

NAME=toolchain-icestorm
ARCH=x86_64
VERSION=2
PACKNAME=$NAME-$ARCH-$VERSION
TARBALL=$PACKNAME.tar.gz
TCDIR=$PWD/$NAME

# Go to code directory
if [ -z "$1" ]; then
    echo "Add your code directory. Ex: ., .., ~/code [clean]"
    exit 1
fi

# Store current dir
WORK=$PWD

# -- Enter into the code directory
cd $1

# Install dependencies
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev

# Install Icestorm
git -C icestorm pull || git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
if [ "$2" == "clean" ]; then
    make clean
fi
mv Makefile Makefile.bk
cp $WORK/packages/build_x86_64/Makefile.icetools Makefile
make -j$nproc PREFIX="~/.platformio/packages/toolchain-icestorm"
make  install DESTDIR=$TCDIR PREFIX=""
mv Makefile.bk Makefile
cd ..

# Install Arachne-PNR
git -C arachne-pnr pull || git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
if [ "$2" == "clean" ]; then
    make clean
fi
make -j$nproc LIBS="-static -static-libstdc++ -static-libgcc -lm"
make install DESTDIR=$TCDIR PREFIX="" ICEBOX="$TCDIR/share/icebox"
cd ..

# Install Yosys
git -C yosys pull || git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
if [ "$2" == "clean" ]; then
    make clean
fi
mv Makefile Makefile.bk
cp $WORK/packages/build_x86_64/Makefile.yosys Makefile
make -j$nproc || exit 1
make install DESTDIR=$TCDIR PREFIX=""
mv Makefile.bk Makefile
cd ..

# Package tarball
cd $WORK
tar -czvf $TARBALL $NAME

# Install toolchain into local
# cp -r $TCDIR $HOME/.platformio/packages/
rm -r $TCDIR
