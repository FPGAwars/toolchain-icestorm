################################################
# icestorm builder for different architectures #
################################################

NAME=toolchain-icestorm
ARCH=windows
VERSION=1

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


# ----------- Build icetime
cd ../icetime
cp $WORK/packages/windows/Makefile.icetime Makefile
make -j$(( $(nproc) -1))
cp icetime.exe $WORK/windist/$NAME/bin

# ----------- Build arachne
cd ../..
git -C arachne-pnr pull || git clone https://github.com/cseed/arachne-pnr.git
cd arachne-pnr
cp $WORK/packages/windows/Makefile.arachne Makefile
make -j$(( $(nproc) -1))
cp bin/arachne-pnr.exe $WORK/windist/$NAME/bin

mkdir -p $WORK/windist/$NAME/share
mkdir -p $WORK/windist/$NAME/share/arachne-pnr
cp $WORK/packages/windows/*.bin $WORK/windist/$NAME/share/arachne-pnr

mkdir -p $WORK/windist/$NAME/share/icebox
cp $WORK/packages/windows/*.txt $WORK/windist/$NAME/share/icebox

# -- Build yosys
cd ..
git -C yosys pull || git clone https://github.com/cliffordwolf/yosys.git
cd yosys
cp $WORK/packages/windows/Makefile.yosys Makefile
make -j$(( $(nproc) -1))
