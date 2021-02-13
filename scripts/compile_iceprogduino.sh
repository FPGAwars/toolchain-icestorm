# -- Compile iceprogduino script

OLIMEX=olimex
COMMIT=208b7a0f70400548b95f21c8936bdb85470cbe5d
GIT_OLIMEX=https://github.com/OLIMEX/iCE40HX1K-EVB.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $OLIMEX || git clone $GIT_OLIMEX $OLIMEX
git -C $OLIMEX pull
git -C $OLIMEX checkout $COMMIT
git -C $OLIMEX log -1

# -- Copy the upstream sources into the build directory
rsync -a $OLIMEX $BUILD_DIR --exclude .git

cd $BUILD_DIR/$OLIMEX

# -- Compile it
cd programmer/iceprogduino 
  gcc -static -c iceprogduino.c -o iceprogduino.o
  gcc -static iceprogduino.o -o iceprogduino
cd ..
cd ..
# -- Test the generated executables
test_bin programmer/iceprogduino/iceprogduino

# -- Copy the executables to the bin dir
cp programmer/iceprogduino/iceprogduino $PACKAGE_DIR/$NAME/bin/iceprogduino


