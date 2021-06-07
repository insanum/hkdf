#!/bin/sh

set -x -e

WOLFSSL_GIT=https://github.com/wolfSSL/wolfssl
WOLFSSL_INCS="-I./wolfssl"
WOLFSSL_LIBS="-L./wolfssl/src/.libs -lwolfssl -lm"

if [ "$1" = clean ]; then
    /bin/rm -rf wolfssl
    /bin/rm -f hkdf
    exit
fi

build_wolfssl()
{
    if [ ! -d ./wolfssl ]; then
        git clone $WOLFSSL_GIT
        cd wolfssl
        ./autogen.sh
        cd -
    fi

    cd wolfssl
    if [ -f Makefile ]; then
        make distclean
    fi
    ./configure --enable-atomicuser \
                --disable-examples \
                --disable-oldtls \
                --enable-hkdf \
                --enable-shared=no \
                --enable-static=yes
    make
    cd -
}

if [ "$1" = wolfssl ]; then
    build_wolfssl
else
    gcc $WOLFSSL_INCS $WOLFSSL_LIBS hkdf.c -o hkdf
fi

