#!/bin/sh

# This is a script to build sane-backend for Ubuntu 14.04 32bit.
# Author: kangear@163.com

# This is your user passwd.
PASSWD=123

if [ `id -u` -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

# 0. sth
echo y | apt-get install libusb-1.0-0-dev build-essential libsane-dev sane sane-utils &&

# 1. clean the dir
make distclean ; 

# 2. configure
./configure \
--prefix=/usr \
--libdir=/usr/lib/arm-linux-gnueabihf \
--sysconfdir=/etc \
--localstatedir=/var \
BACKENDS="canon_dr" \
PRELOADABLE_BACKENDS="canon_dr" \
--enable-libusb_1_0 \
--enable-static \
--disable-dynamic \
--enable-preload &&

# 3. build & install
make -j32 &&

# make install &&

# 静态编译scanimage
cd frontends &&
gcc -g -O2 -W -Wall -Wcast-align -Wcast-qual -Wmissing-declarations -Wmissing-prototypes -Wpointer-arith -Wreturn-type -Wstrict-prototypes -pedantic -ansi -I/usr/local/include/libusb-1.0 -o scanimage scanimage.o stiff.o  ../backend/.libs/libsane.a -L/usr/local/lib -lm -lieee1284 -ljpeg -lusb-1.0 -lrt -lpthread ../sanei/.libs/libsanei.a ../lib/.libs/liblib.a ../lib/.libs/libfelib.a -pthread -static &&
cd - &&

# 4. cp canon_dr.conf which can not be cp during install.
# cp backend/canon_dr.conf /etc/sane.d/canon_dr.conf &&

# 5. ln libsane-canon_dr.so.1.0.25 which can not be link during install.
# ln -sf /usr/lib/i386-linux-gnu/sane/libsane-canon_dr.so.1.0.25 /usr/lib/i386-linux-gnu/sane/libsane-canon_dr.so.1 &&

make install DESTDIR=$PWD/_install -j32

echo "build done. running test app..."

# 6. run test
export SANE_DEBUG_DLL=255 SANE_DEBUG_CANON_DR=255
scanimage -L 2>&1 | grep canon

# if there is a Scanner has be detected, then you can run this by hand to test.
# sudo simple-scan



 
