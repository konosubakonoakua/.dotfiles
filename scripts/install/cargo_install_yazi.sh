#INFO: tested, works good

PKG_FOLDER=~/Downloads/yazi
INSTALL_PREFIX=$HOME/.local

if [ -d $PKG_FOLDER ]; then
	echo "$PKG_FOLDER already exists"
	cd $PKG_FOLDER
	git pull origin
else
	git clone https://github.com/sxyazi/yazi $PKG_FOLDER
	cd $PKG_FOLDER
fi

cargo build --release && cp target/release/yazi $INSTALL_PREFIX/bin/yazi
