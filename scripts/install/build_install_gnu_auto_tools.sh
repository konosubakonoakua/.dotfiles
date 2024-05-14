# https://www.gnu.org/software/automake/faq/autotools-faq.html#How-do-I-install-the-Autotools-_0028as-user_0029_003f
# GNU_MIRROR="https://gfit.savannah.gnu.org"
# git clone "$GNU_MIRROR/gperf.git" --depth=1 &
# GNULIB_PATH="$HOME/.local/opt/gnulib"
# LOCAL_BIN_PATH="$HOME/.local/bin"
# mkdir -p $GNULIB_PATH
# mkdir -p $LOCAL_BIN_PATH
# git clone "$GNU_MIRROR/gnulib.git" --depth=1 $GNULIB_PATH
# rm -f "$LOCAL_BIN_PATH/gnulib-tool"
# ln -s "$GNULIB_PATH/gnulib-tool" "$LOCAL_BIN_PATH/gnulib-tool"
# export GNULIB_SRCDIR=$GNULIB_PATH
#
#
# git clone "$GNU_MIRROR/git/gettext.git" --depth=1 &
# git clone "$GNU_MIRROR/git/texinfo.git" --depth=1 &
# git clone "$GNU_MIRROR/r/m4.git" --branch=branch-2.0 &
# git clone "$GNU_MIRROR/git/autoconf.git" --depth=1 &
# git clone "$GNU_MIRROR/git/automake.git" --depth=1 &
# git clone "$GNU_MIRROR/git/libtool.git" --depth=1 &

# INFO: git repo do not have configure file
# use mirror releases instead
AUTOTOOLS_PKG="$HOME/Downloads/autotools"
AUTOCONF_VER="latest"
AUTOMAKE_VER="1.9"
M4_VER="latest"
LIBTOOL_VER="2.4"
MIRROR="https://mirrors.bfsu.edu.cn/gnu"
mkdir -p $AUTOTOOLS_PKG
pushd $AUTOTOOLS_PKG
ver=
tarball=

repos=(m4 autoconf automake libtool)
for repo in "${repos[@]}"; do
  echo "##########################$repo##########################"
  ver=${repo^^}_VER
  tarball=$repo-${!ver}.tar.gz
  wget "$MIRROR/$repo/$tarball" && mkdir -p $repo && tar zxvf $tarball -C $repo --strip-components=1
  pushd $repo
  test -f configure || ./bootstrap || ./autogen.sh
  ./configure --prefix="$HOME/.local" && make -j8 install
  popd
  echo "#########################################################"
done

popd
