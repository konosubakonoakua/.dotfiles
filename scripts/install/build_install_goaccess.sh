#INFO: tested, works good

deps=(automake autopoint libmaxminddb0 libmaxminddb-dev mmdb-bin gettext)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

PKG_FOLDER=~/Downloads/goaccess
INSTALL_PREFIX=$HOME/.local/

if [ -d $PKG_FOLDER ]; then
	echo "$PKG_FOLDER already exists"
	cd $PKG_FOLDER
else
	git clone https://github.com/allinurl/goaccess.git $PKG_FOLDER
fi

cd $PKG_FOLDER
autoreconf -fiv
./configure --enable-utf8 --enable-geoip=mmdb --prefix=$INSTALL_PREFIX
make -j8
make -j8 install
