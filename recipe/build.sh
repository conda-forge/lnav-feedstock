#!/bin/bash

set -exo pipefail

export CFLAGS="${CFLAGS:-} -D_DEFAULT_SOURCE -D_BSD_SOURCE"
export CXXFLAGS="${CXXFLAGS:-} -fpermissive -std=c++17 -D_DEFAULT_SOURCE -D_BSD_SOURCE"

# Build prqlc-c library in advance
cd src/third-party/liblnav-rs-ext
cargo-bundle-licenses --format yaml --output ${SRC_DIR}/THIRDPARTY.yml
cargo build --release
cd ${SRC_DIR}
PRQLC_DIR=${SRC_DIR}/src/third-party/liblnav-rs-ext/target
mkdir -p ${PRQLC_DIR}/release
find "${PRQLC_DIR}" -type f \( -name 'liblnav_rs_ext.a' -o -name 'liblnav_rs_ext.d' \) \
    -exec cp {} "${PRQLC_DIR}/release/" \;

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
