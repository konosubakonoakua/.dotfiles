#!/bin/bash

#INFO: tested, works

INSTALL_PREFIX=$HOME/.local
PKG_PREFIX=arm-gnu-toolchain-
PKG_TYPE=.tar.xz
PKG_ASC=.tar.xz.asc
PKG_SHA256ASC=.tar.xz.sha256asc
PKG_FOLDER=~/Downloads/armgnu

print_divider() {
	echo ""
	echo "------------------------------------"
	echo ""
}

HOST_OS_ALL=(x86_64 aarch64 mingw-w64-i686 darwin-x86_64)
PS3="Please select a host os version: "
select os_selected in "${HOST_OS_ALL[@]}"; do
	if [ "$os_selected" != "" ]; then
		HOST_OS=$os_selected
		echo "HOST_OS: $HOST_OS"
		break
	else
		echo "invalid HOST_OS: $HOST_OS"
		exit 1
	fi
done

print_divider
VARIANT_ALL=(arm-none-eabi arm-none-linux-gnueabihf aarch64-none-elf aarch64-none-linux-gnu aarch64_be-none-linux-gnu)
PS3="Please select a variant version: "
select variant_selected in "${VARIANT_ALL[@]}"; do
	if [ "$variant_selected" != "" ]; then
		VARIANT=$variant_selected
		echo "VARIANT: $VARIANT"
		break
	else
		echo "invalid VARIANT: $VARIANT"
		exit 1
	fi
done

PKG_INSTALL_PATH="$INSTALL_PREFIX/opt/armgnu/$VARIANT"
PKG_INSTALL_PATH_CURRENT="$INSTALL_PREFIX/opt/armgnu/$VARIANT/current"
DOWNLOAD_URL=https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
VERSION_GREP_REGEX="$PKG_PREFIX(.*?)-$HOST_OS-$VARIANT$PKG_TYPE"

case "$1" in
env)
	print_divider
	PKG_INSTALLED=($(find "$PKG_INSTALL_PATH" -mindepth 1 -maxdepth 1 -type d ! -name "current" ! -name "."))
	if [[ -z "$PKG_INSTALLED" ]]; then
		exit 1
	fi
	PS3="select installed arm gnu toolchains:"
	select installed in "${PKG_INSTALLED[@]}"; do
		if [[ "$installed" != "" ]]; then
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

	(
		source ~/.bashrc
		if [[ ":$PATH:" != *":$PKG_INSTALL_PATH_CURRENT/bin"* ]]; then
			echo 'export PATH="$PATH:'"$PKG_INSTALL_PATH_CURRENT/bin"'"' >>~/.bashrc
			echo "$PKG_INSTALL_PATH_CURRENT/bin added to "'$PATH'
		else
			echo "$PKG_INSTALL_PATH_CURRENT/bin already added to "'$PATH'
		fi
		exit 0
	)

	exit 0
	;;
install) ;;
*)
  echo "install_arm_gnu_toolchain.sh [env|install]"
	exit 1
	;;
esac

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

print_divider
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
	if [[ "" == "$ver_selected" ]]; then
		echo "no valid version selected: $choice"
		exit 1
	else
		VERSION=$ver_selected
		echo "VERSION: $VERSION"
		break
	fi
done

REAL_DOWNLOAD_URL=https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu
PKG_FULL_NAME=$PKG_PREFIX$VERSION-$HOST_OS-$VARIANT$PKG_TYPE
PKG_FULL_NAME_BASENAME=$(echo $PKG_FULL_NAME | sed "s/$PKG_TYPE//")
PKG_DOWNLOAD_URL="$REAL_DOWNLOAD_URL/$VERSION/binrel/$PKG_FULL_NAME"
PKG_INSTALL_PATH_VARIANT_FOLDER="$PKG_INSTALL_PATH/$PKG_FULL_NAME_BASENAME"
PKG_INSTALL_PATH_VARIANT_FOLDER=${PKG_INSTALL_PATH_VARIANT_FOLDER/rel/Rel}

for VAR in "${_VARS_TO_PRINT[@]}"; do
	printvar $VAR
	echo "------------------------"
done

# exit 1

mkdir -p $PKG_FOLDER
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
	echo "extracting into $PKG_INSTALL_PATH_VARIANT_FOLDER"
	(
		tar -Jxf $PKG_FULL_NAME -C $PKG_INSTALL_PATH --checkpoint=500 --checkpoint-action=dot
		if [[ ! $? -eq 0 ]]; then
			rm -rf $PKG_INSTALL_PATH_VARIANT_FOLDER $PKG_FULL_NAME
			exit 1
		fi
	)
	echo "extracted to $PKG_INSTALL_PATH_VARIANT_FOLDER"
	print_divider
else
	echo "$PKG_INSTALL_PATH_VARIANT_FOLDER already exits."
	print_divider
fi
