#!/bin/bash

print_divider() {
	echo ""
	echo "------------------------------------"
	echo ""
}

BUILDROOT_URL="https://buildroot.org/downloads"
LOCAL_DIR="$HOME/.local/opt/buildroot"
DOWNLOAD_DIR="$HOME/Downloads/buildroot"

mkdir -p $LOCAL_DIR
mkdir -p $DOWNLOAD_DIR

buildroot_versions=($(wget -q -O - $BUILDROOT_URL | grep -o 'buildroot-[0-9.]*.tar.xz' | sort -V -r | uniq))

PS3="Choose a Buildroot version (default is the latest): "
select version in "${buildroot_versions[@]}"; do
	if [ -n "$version" ]; then
		selected_version="$version"
		break
	else
		selected_version="${buildroot_versions[0]}"
		echo "Using default version: ${selected_version}"
		break
	fi
done

select_version_download_path=$DOWNLOAD_DIR/$selected_version
echo "$DOWNLOAD_DIR" "$BUILDROOT_URL/$selected_version"
echo "select_version_download_path" "$select_version_download_path"

print_divider

if [ -f $select_version_download_path ]; then
	echo "The target package already exists in the download directory. Skipping the download."
else
	echo "$select_version_download_path"
	wget -P "$DOWNLOAD_DIR" "$BUILDROOT_URL/$selected_version"
fi

if [ -d $(echo "$LOCAL_DIR/$selected_version" | sed 's/.tar.xz//') ]; then
	echo "The target directory already exists. Skipping the extraction."
else
	# mkdir -p $LOCAL_DIR/buildroot-$selected_version && echo "created."
	tar -Jxf $DOWNLOAD_DIR/$selected_version -C $LOCAL_DIR --checkpoint=500 --checkpoint-action=dot
	# tar -Jxvf $DOWNLOAD_DIR/$selected_version -C $LOCAL_DIR/buildroot-$selected_version
fi

print_divider

installed_versions=($(find "$LOCAL_DIR" -maxdepth 1 -mindepth 1 -type d -name "buildroot-*" | sort -V -r | uniq))

PS3="Choose an installed Buildroot version (default is the latest): "
select version in "${installed_versions[@]}"; do
	if [ -n "$version" ]; then
		selected_version="$version"
		break
	else
		selected_version="${installed_versions[-1]}"
		break
	fi
done

print_divider

ln -sfn "$selected_version" "$LOCAL_DIR/current"

# source ~/.bashrc
# if [[ ":$PATH:" != *":$LOCAL_DIR/current/output/host/bin:"* ]]; then
# 	echo 'export PATH="$PATH:'"$LOCAL_DIR/current/output/host/bin"'"' >>~/.bashrc
# fi
#
if ! grep -q "BUILDROOT_CURRENT" ~/.bashrc; then
	echo 'export BUILDROOT_CURRENT='"$LOCAL_DIR/current" >>~/.bashrc
fi
echo "Buildroot $(basename "$selected_version") installation completed."

print_divider
