libc_ver_lt () {
  bc_cmd="$(ldd --version | rg 'GLIBC (\d\.\d{2})' -or '$1') < $1"
  return $(echo "$bc_cmd" | bc)
}
