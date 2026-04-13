#!/bin/bash

set -exo pipefail

export CFLAGS="${CFLAGS:-} -D_DEFAULT_SOURCE -D_BSD_SOURCE"
export CXXFLAGS="${CXXFLAGS:-} -fpermissive -std=c++17 -D_DEFAULT_SOURCE -D_BSD_SOURCE"

./configure \
    --prefix=${PREFIX} \
    --with-sqlite3=${PREFIX} \
    --with-readline=${PREFIX} \
    --with-libarchive=${PREFIX} \
    --with-ncurses=${PREFIX} \
    --with-pcre2=${PREFIX} \
    --with-libcurl=${PREFIX} \
    --with-jemalloc=${PREFIX} \
    --disable-dependency-tracking \
    --disable-silent-rules

make -j${CPU_COUNT} V=1
make install
