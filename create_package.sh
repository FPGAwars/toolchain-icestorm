# -- Create package script

cd $PACKAGE_DIR

if [ $ARCH == "linux_x86_64" ]; then
  tar vzcf $NAME-$ARCH-$VERSION.tar.gz $NAME
fi

if [ $ARCH == "windows" ]; then
  zip -r $NAME-$ARCH-$VERSION.zip $NAME
fi
