# -- Compile Icoprog script for RPI

ICOTOOLS=icotools
GIT_ICOTOOLS=https://github.com/cliffordwolf/icotools.git

J=$(($(nproc)-1))

## Icoprog

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $ICOTOOLS || git clone --depth=1 $GIT_ICOTOOLS $ICOTOOLS
git -C $ICOTOOLS pull
echo ""
git -C $ARACHNE log -1

# -- Copy the upstream sources into the build directory
rsync -a $ICOTOOLS $BUILD_DIR --exclude .git

cd $BUILD_DIR/$ICOTOOLS

# -- Compile it
arm-linux-gnueabihf-gcc -o icoprog/icoprog -Wall -Os icoprog/icoprog.cc -D GPIOMODE -static -lrt -lstdc++

# -- Test the generated executables
test_bin icoprog/icoprog

# -- Copy the executables to the bin dir
cp icoprog/icoprog $PACKAGE_DIR/$NAME/bin
