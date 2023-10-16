#INFO: tested, works good

# sudo apt-get install autoconf automake libtool curl make g++ unzip
#
PKG_FOLDER=~/Downloads/protobuf
INSTALL_PREFIX=$HOME/.local/

if [ -d $PKG_FOLDER ]; then
	echo "$PKG_FOLDER already exists"
	cd $PKG_FOLDER
	git reset --hard HEAD && git checkout 3.20.x
else
	git clone -b 3.20.x https://github.com/protocolbuffers/protobuf.git $PKG_FOLDER
	cd $PKG_FOLDER
fi

git submodule update --init --recursive
cd cmake && mkdir -p build && cd build
cmake -DCMAKE_CXX_STANDARD=11 -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -Dprotobuf_BUILD_TESTS=OFF -DBUILD_SHARED_LIBS=1 ..
make -j8 install
