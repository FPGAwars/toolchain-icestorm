#######################################################
# Clean the files generated for building the package  #
# for linux x86_64                                    #
#######################################################

# -- Folder for storing the generated packages
PACK_DIR=packages

# -- Target architecture
ARCH=linux_x86_64

# -- Directory for compiling the tools
BUILD_DIR=build_$ARCH

# -- toolchain name
NAME=toolchain-icestorm


# -- Remove the final package
rm -r -f $PACK_DIR/$NAME-$ARCH-*


# -- Remove the build dir
rm -r -f $BUILD_DIR
