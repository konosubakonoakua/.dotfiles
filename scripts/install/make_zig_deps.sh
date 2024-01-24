PKG_FOLDER=$HOME/Downloads/zig_deps

INSTALL_PREFIX=$HOME/.local/

LIBXML2_VER=2.11.5
LIBXML2_PKG=v$LIBXML2_VER.tar.gz
LIBXML2_FOLDER=libxml2-$LIBXML2_VER

LIBZSTD_VER=1.5.5
LIBZSTD_PKG=zstd-$LIBZSTD_VER.tar.gz
LIBZSTD_FOLDER=zstd-$LIBZSTD_VER

mkdir -p $INSTALL_PREFIX
mkdir -p $PKG_FOLDER && cd $PKG_FOLDER || exit 1

[ ! -f $LIBXML2_PKG ] && { wget https://github.com/GNOME/libxml2/archive/refs/tags/$LIBXML2_PKG || exit 1; }
[ ! -d $LIBXML2_FOLDER ] && { tar -xzf $LIBXML2_PKG || exit 1; }
[ ! -f $LIBZSTD_PKG ] && { wget https://github.com/facebook/zstd/releases/download/v$LIBZSTD_VER/$LIBZSTD_PKG || exit 1; }
[ ! -d $LIBZSTD_FOLDER ] && { tar -xzf $LIBZSTD_PKG || exit 1; }

# RES0=$(
cd $LIBXML2_FOLDER &&
	{ ./autogen.sh --prefix=$INSTALL_PREFIX && make install -j8; }
# { echo "libxml2 install failed " && exit 1; }
# )

cd ..

# RES1=$(
cd $LIBZSTD_FOLDER &&
	{ PREFIX=$INSTALL_PREFIX make install -j8; }
# )
