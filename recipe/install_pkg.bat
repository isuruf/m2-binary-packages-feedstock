mkdir %LIBRARY_PREFIX%
xcopy %SRC_DIR%\binary-%PKG_NAME%\ %LIBRARY_PREFIX%\ /s /e /y

if "%PKG_NAME%" == "m2-file" (
  rmdir /s /q %PREFIX%\Library\usr\lib\python3.11\site-packages\__pycache__\
)

del %LIBRARY_PREFIX%\.BUILDINFO
del %LIBRARY_PREFIX%\.MTREE
del %LIBRARY_PREFIX%\.PKGINFO

if NOT "%PKG_NAME%" == "m2-msys2-launcher" (
  if NOT "%PKG_NAME%" == "m2-base" (
    if not exist %LIBRARY_PREFIX%\usr exit 1
  )
)

if "%PKG_NAME%" == "m2-ca-certificates" (
  mkdir %PREFIX%\Scripts
  copy %RECIPE_DIR%\.m2-ca-certificates-post-link.bat %PREFIX%\Scripts\
)

if "%PKG_NAME%" == "m2-filesystem" (
  REM cygpath has special casing for /bin
  REM %LIBRARY_PREFIX%/bin should be mounted to /bin, but /bin is a special path
  REM See https://github.com/msys2/msys2-runtime/blob/28d69fba269dd4a9f4281f8af7c2775292241e8b/winsup/cygwin/mount.cc#L1685-L1686
  REM cygpath -w %LIBRARY_PREFIX%\bin is /bin, but
  REM cygpath -u /bin is %LIBRARY_PREFIX%\usr\bin
  REM This leads to %LIBRARY_PREFIX%\bin getting dropped after two
  REM conversions.
  REM To prevent this we mount %LIBRARY_PREFIX%\bin to /conda_bin
  REM see https://cygwin.com/cygwin-ug-net/using.html#mount-table
  setlocal EnableDelayedExpansion
  set LF=^


  REM Keep the 2 empty lines above so LF is set to linefeed character!
  <nul (set/p=!LF!%LIBRARY_PREFIX:\=/%/bin /conda_bin ntfs auto!LF!) >> %LIBRARY_PREFIX%\etc\fstab || call;
)
