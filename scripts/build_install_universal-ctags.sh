#INFO: tested, works good

#########################################
# https://docs.ctags.io/en/latest/autotools.html
#########################################

deps=(
	gcc make
	pkg-config autoconf automake
	python3-docutils
	libseccomp-dev
	libjansson-dev
	libyaml-dev
	libxml2-dev
)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

GIT_SRC=~/Downloads/ctags
git clone https://github.com/universal-ctags/ctags.git $GIT_SRC
[[ ! -d $GIT_SRC ]] && return 1

cd $GIT_SRC

./autogen.sh && ./configure --prefix=$HOME/.local # defaults to /usr/local

# may require extra privileges depending on where to install
make -j && make install
