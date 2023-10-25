#!/bin/bash

#INFO: tested, works

INSTALL_PREFIX=$HOME/.local
PKG_INSTALL_PATH="$INSTALL_PREFIX/opt/armgnu"
PKG_INSTALL_PATH_CURRENT="$INSTALL_PREFIX/opt/armgnu/current"
PKG_PREFIX=arm-gnu-toolchain-
PKG_TYPE=.tar.xz
PKG_ASC=.tar.xz.asc
PKG_SHA256ASC=.tar.xz.sha256asc
PKG_FOLDER=~/Downloads/armgnu

HOST_OS_ALL=(x86_64 aarch64 mingw-w64-i686 darwin-x86_64)
VARIANT_ALL=(arm-none-eabi arm-none-linux-gnueabihf aarch64-none-elf aarch64-none-linux-gnu aarch64_be-none-linux-gnu)
VARIANT=arm-none-eabi
HOST_OS=x86_64

DOWNLOAD_URL=https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
VERSION_GREP_REGEX="$PKG_PREFIX(.*?)-$HOST_OS-$VARIANT$PKG_TYPE"

case "$1" in
env)
	PKG_INSTALLED=($(find "$PKG_INSTALL_PATH" -mindepth 1 -maxdepth 1 -type d ! -name "current" ! -name "."))

	PS3="select installed arm gnu toolchains:"
	select installed in "${PKG_INSTALLED[@]}"; do
		if [[ -n $installed ]]; then
			rm -rf $PKG_INSTALL_PATH_CURRENT
			ln -s "$installed" $PKG_INSTALL_PATH_CURRENT && echo "$PKG_INSTALL_PATH_CURRENT soft linked to $installed"
			[ $? -eq 0 ] && break
			echo "$PKG_INSTALL_PATH_CURRENT failed to soft linked to $installed"
			exit 1
		else
			echo "invalid select: $choice"
			exit 1
		fi
	done

	if [[ ":$PATH:" != *":$PKG_INSTALL_PATH_CURRENT/bin"* ]]; then
		echo 'export PATH="$PATH:'"$PKG_INSTALL_PATH_CURRENT/bin"'"' >>~/.bashrc
		echo "$PKG_INSTALL_PATH_CURRENT/bin added to "'$PATH'
	else
		echo "$PKG_INSTALL_PATH_CURRENT/bin already added to "'$PATH'
	fi

	exit 0
	;;
install) ;;
*)
	exit 1
	;;
esac

if [[ "$1" == "env" ]]; then
fi

_VARS_TO_PRINT=(
	HOST_OS_ALL
	VARIANT_ALL
	VARIANT
	HOST_OS
	PKG_PREFIX
	PKG_TYPE
	PKG_ASC
	PKG_SHA256ASC
	INSTALL_PREFIX
	PKG_FOLDER
	DOWNLOAD_URL
	VERSION_GREP_REGEX
	VERSION_ALL
	VERSION_ARRAY
	VERSION
	REAL_DOWNLOAD_URL
	PKG_FULL_NAME
	PKG_FULL_NAME_BASENAME
	PKG_DOWNLOAD_URL
	PKG_INSTALL_PATH
	PKG_INSTALL_PATH_VARIANT_FOLDER
)

function printvar() {
	local varname="$1"
	if [[ -n "$varname" ]]; then
		echo "$varname: ${!varname}" # ref
	fi
}

#VERSION_GREP_REGEX=arm-gnu-toolchain-\K.*(?=-x86_64-arm-none-eabi.tar.xz)
VERSION_ALL=$(
	curl -L $DOWNLOAD_URL | grep -oP "$VERSION_GREP_REGEX" |
		sort -r --version-sort | uniq |
		sed "s/$PKG_PREFIX//" | sed "s/-$HOST_OS-$VARIANT$PKG_TYPE//" |
		grep -v "darwin"
)
PS3="Please select a version: "

VERSION_ARRAY=($(echo "$VERSION_ALL" | awk '{for (i=1; i<=NF; i++) print $i}'))
VERSION=""
select ver_selected in "${VERSION_ARRAY[@]}"; do
	VERSION=$ver_selected
	break
done

echo "$VERSION"
if [[ "" == "$VERSION" ]]; then
	echo "no valid version selected"
	exit 1
fi

REAL_DOWNLOAD_URL=https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu
PKG_FULL_NAME=$PKG_PREFIX$VERSION-$HOST_OS-$VARIANT$PKG_TYPE
PKG_FULL_NAME_BASENAME=$(echo $PKG_FULL_NAME | sed "s/$PKG_TYPE//")
PKG_DOWNLOAD_URL="$REAL_DOWNLOAD_URL/$VERSION/binrel/$PKG_FULL_NAME"
PKG_INSTALL_PATH_VARIANT_FOLDER="$PKG_INSTALL_PATH/$PKG_FULL_NAME_BASENAME"

for VAR in "${_VARS_TO_PRINT[@]}"; do
	printvar $VAR
	echo "------------------------"
done

# exit 1

[[ ! -d $PKG_FOLDER ]] && mkdir -p $PKG_FOLDER

cd $PKG_FOLDER

if [[ ! -f $PKG_FULL_NAME ]]; then
	wget $PKG_DOWNLOAD_URL || exit 1
else
	echo "$PKG_FULL_NAME already exits."
	echo "Use cached version."
fi

mkdir -p $PKG_INSTALL_PATH

if [[ ! -d "$PKG_INSTALL_PATH_VARIANT_FOLDER" ]]; then
	pwd && ls
	mkdir -p $PKG_INSTALL_PATH_VARIANT_FOLDER
	echo "extracting"
	tar -Jxf $PKG_FULL_NAME -C $PKG_INSTALL_PATH --checkpoint=100 --checkpoint-action=dot
	if [[ ! $? -eq 0 ]]; then
		rm -r $PKG_INSTALL_PATH_VARIANT_FOLDER
		exit 1
	fi
	echo ""
	echo "extracted to $PKG_INSTALL_PATH_VARIANT_FOLDER"
else
	echo "$PKG_INSTALL_PATH_VARIANT_FOLDER already exits."
fi
