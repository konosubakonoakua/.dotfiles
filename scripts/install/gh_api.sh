# https://github.com/konosubakonoakua/installer
get_github_release_urls() {
  [ -z $1 ] && return 1
  curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po '"browser_download_url": "\K[^"]*'
}
