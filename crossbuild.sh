################################################
# icestorm builder for different architectures #
################################################

NAME=toolchain-icestorm
ARCH=windows
VERSION=1
$TCDIR=$PWD/windist/$NAME

# Store current dir
WORK=$PWD

# Enter into the code directory
mkdir -p winbuild; cd winbuild

# Install dependencies
sudo apt-get install cmake  git-core mingw-w64 mingw-w64-tools zip

# download icestorm
git -C icestorm pull || git clone https://github.com/cliffordwolf/icestorm.git
cd icestorm

## -------- Build iceprog
cd iceprog
cp $WORK/packages/windows/Makefile.iceprog Makefile
make -j$(( $(nproc) -1))

mkdir -p $WORK/windist
mkdir -p $WORK/windist/$NAME
mkdir -p $WORK/windist/$NAME/bin
cp iceprog.exe $WORK/windist/$NAME/bin


# ----------- Building icetime
cd ../icetime
cp $WORK/packages/windows/Makefile.icetime Makefile
make -j$(( $(nproc) -1))
cp icetime.exe $WORK/windist/$NAME/bin
