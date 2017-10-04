# -- Create package script

# -- Copy templates/package-template.json
cp -r $WORK_DIR/build-data/templates/package-template.json $PACKAGE_DIR/$NAME/package.json

if [ $ARCH == "linux_x86_64" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"linux_x86_64\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "linux_i686" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"linux_i686\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "linux_armv6l" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"linux_armv6l\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "linux_armv7l" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"linux_armv7l\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "linux_aarch64" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"linux_aarch64\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "windows_x86" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"windows\", \"windows_x86\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "windows_amd64" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"windows_amd64\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "darwin" ]; then
  sed -i "" "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "" "s/%SYSTEM%/\"darwin\", \"darwin_x86_64\", \"darwin_i386\"/;" $PACKAGE_DIR/$NAME/package.json
fi

## --Create a tar.gz package

cd $PACKAGE_DIR/$NAME

tar -czvf ../$NAME-$ARCH-$VERSION.tar.gz *
