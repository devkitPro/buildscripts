#---------------------------------------------------------------------------------
# build and install mn10200 binutils
#---------------------------------------------------------------------------------

# Use modern config.sub for aarch64 host
cp binutils-$BINUTILS_VER/config.sub binutils-$MN_BINUTILS_VER/config.sub

mkdir -p mn10200/binutils
pushd mn10200/binutils

if [ ! -f configured-binutils ]
then
        ../../binutils-$MN_BINUTILS_VER/configure \
        --prefix=$prefix --target=mn10200 --disable-nls --disable-debug \
        --disable-multilib \
        --disable-werror $CROSS_PARAMS \
        || { echo "Error configuing mn10200 binutils"; exit 1; }
        touch configured-binutils
fi

if [ ! -f built-binutils ]
then
        $MAKE || { echo "Error building mn10200 binutils"; exit 1; }
        touch built-binutils
fi

if [ ! -f installed-binutils ]
then
        $MAKE install || { echo "Error installing mn10200 binutils"; exit 1; }
        touch installed-binutils
fi

popd
