mkdir $PREFIX/Library
cp -R $SRC_DIR/binary-${PKG_NAME}/* $PREFIX/Library/

rm $PREFIX/Library/.BUILDINFO
rm $PREFIX/Library/.MTREE
rm $PREFIX/Library/.PKGINFO

if [[ "${PKG_NAME}" == "m2-file" ]]; then
  rm -rf $PREFIX/Library/usr/lib/python3.11/site-packages/__pycache__/
fi

if [[ "${PKG_NAME}" != "m2-msys2-launcher" && "${PKG_NAME}" != "m2-base" ]]; then
  test -d $PREFIX/Library/usr
fi

if [[ "${PKG_NAME}" == "m2-ca-certificates" ]]; then
  mkdir $PREFIX/Scripts
  cp $RECIPE_DIR/.m2-ca-certificates-post-link.bat $PREFIX/Scripts/
fi
