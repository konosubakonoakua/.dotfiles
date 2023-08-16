#INFO: tested, works good

#########################################
# $ make install PREFIX=$HOME/.local
# $ ./fnlfmt mycode.fnl # prints formatted code to standard out
# $ ./fnlfmt --fix mycode.fnl # replaces the file with formatted code
# $ curl localhost:8080/my-file.fnl | ./fnlfmt - # pipe to stdin
#########################################

PKG_FOLDER=~/Downloads/fnlfmt
INSTALL_PREFIX=$HOME/.local/
REPO_URL=https://git.sr.ht/~technomancy/fnlfmt
rm -rf $PKG_FOLDER
if [ ! -d $PKG_FOLDER ]; then
	git clone $REPO_URL $PKG_FOLDER
fi

cd $PKG_FOLDER && make install PREFIX=$INSTALL_PREFIX
chmod +x $INSTALL_PREFIX/bin/fnlfmt

echo "fnlfmt installed into $INSTALL_PREFIX"
