# -- Create package script

cd $PACKAGE_DIR

if [ $ARCH == "windows" ]; then
  zip -r $NAME-$ARCH-$VERSION.zip $NAME
else
  tar vzcf $NAME-$ARCH-$VERSION.tar.gz $NAME
fi
