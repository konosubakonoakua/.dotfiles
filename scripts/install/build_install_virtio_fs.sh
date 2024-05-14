if [ -z dummy ]; then

	git clone https://github.com/swig/swig.git --depth=1
	cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -Bbuild
	make -C build -j install

	git clone https://github.com/stevegrubb/libcap-ng.git --depth=1
	cd libcap-ng
	./autogen.sh
	./configure --prefix=$HOME/.local
	make -j install

	if which cargo >/dev/null; then
		cd $PKG_FOLDER
		git clone https://gitlab.com/virtio-fs/virtiofsd.git --depth=1
		cd virtiofsd
		cargo build --release
	fi

else

pushd $HOME/Downloads/
wget https://gitlab.com/virtio-fs/virtiofsd/-/jobs/artifacts/main/download?job=publish -O virtiofsd.zip && \
	unzip virtiofsd && \
	find -name virtiofsd -exec sh -c "cp -f {} $HOME/.local/bin/virtiofsd" \;
popd

fi
