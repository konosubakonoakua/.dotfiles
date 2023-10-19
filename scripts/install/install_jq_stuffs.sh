# DOWNLOAD_FOLDER:
# INSTALL_FOLDER:
# GITHUB_URL:
# GITHUB_RELEASE_SUBURL:
# GITHUB_RELEASE_DOWNLOAD_SUBURL:
# VERSION_GREP_PATTERN:
# VERSION_SED_PATTERN:
# VERSION_PREFIX:
# VERSION_SUFFIX:
# EXEC_NAME:
# EXEC_PKG_NAME_PATTERN:
# EXEC_RAW_NO_NEED_TO_UNZIP:
# UNZIP_CMD_PREFIX:

./install_from_github_release.sh \
	~/Downloads/jq \
	~/.local/bin \
	'https://github.com' \
	'jqlang/jq/releases' \
	'jqlang/jq/releases/download' \
	'jq [[:digit:]]{1,2}\.[[:digit:]]{1,2}' \
	's/jq //' \
	'jq-' \
	'' \
	'jq' \
	'jq-linux-amd64' \
	'nozip' \
	'tar -zxvf'

./install_from_github_release.sh \
	~/Downloads/jqp \
	~/.local/bin \
	'https://github.com' \
	'noahgorstein/jqp/releases' \
	'noahgorstein/jqp/releases/download' \
	'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' \
	's/v//' \
	'v' \
	'' \
	'jqp' \
	'jqp_linux_x86_64.tar.gz' \
	'zip' \
	'tar -zxvf'

./install_from_github_release.sh \
	~/Downloads/gojq \
	~/.local/bin \
	'https://github.com' \
	'itchyny/gojq/releases' \
	'itchyny/gojq/releases/download' \
	'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' \
	's/v//' \
	'v' \
	'' \
	'gojq' \
	'gojq_v###_linux_amd64.tar.gz' \
	'zip' \
	'tar -zxvf'

# if [[ ! "nozip" -eq "${12}" ]]; then
# 	case "$ZIP_TYPE" in
# 	zip) ;;
# 	xz) ;;
# 	gz) ;;
# 	bz2) ;;
# 	lzip) ;;
# 	*) ;;
# 	esac
# fi
