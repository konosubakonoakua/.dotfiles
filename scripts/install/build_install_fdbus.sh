#INFO: tested, works good
#TODO: add protoc detection

# sudo apt-get install autoconf automake libtool curl make g++ unzip
#
PKG_FOLDER=~/Downloads/fdbus
INSTALL_PREFIX=$HOME/.local/

if [ -d $PKG_FOLDER ]; then
	echo "$PKG_FOLDER already exists"
	cd $PKG_FOLDER
	# git reset --hard HEAD
else
	# git clone https://github.com/jeremyczhen/fdbus.git $PKG_FOLDER
	git clone https://github.com/konosubakonoakua/fdbus-mirror $PKG_FOLDER
	cd $PKG_FOLDER
fi

mkdir -p build/install
cd build
cmake -DSYSTEM_ROOT=$INSTALL_PREFIX -DCMAKE_INSTALL_PREFIX=install ../cmake
PATH=$INSTALL_PREFIX/bin:$PATH make -j8 #set PATH to the directory where protoc can be found
