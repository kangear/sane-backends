#!/bin/sh

# This is a script to build sane-backend for Ubuntu 14.04 32bit.
# Author: kangear@163.com

# This is your user passwd.
PASSWD=123

# 1. clean the dir
make distclean ; 

# 2. configure
./configure --prefix=/usr --libdir=/usr/lib/i386-linux-gnu --sysconfdir=/etc --localstatedir=/var  --enable-avahi BACKENDS="canon_dr test" &&

# 3. build & install
make -j32 && echo "$PASSWD" | sudo -S make install &&

# 4. cp canon_dr.conf which can not be cp during install.
echo "$PASSWD" | sudo -S cp backend/canon_dr.conf /etc/sane.d/canon_dr.conf &&

# 5. ln libsane-canon_dr.so.1.0.25 which can not be link during install.
echo "$PASSWD" | sudo -S ln -sf /usr/lib/i386-linux-gnu/sane/libsane-canon_dr.so.1.0.25 /usr/lib/i386-linux-gnu/sane/libsane-canon_dr.so.1 &&

echo "build done. running test app..."

# 6. run test
export SANE_DEBUG_DLL=255 SANE_DEBUG_CANON_DR=255 &&
echo "$PASSWD" | sudo -S scanimage -L 2>&1 | grep canon

# if there is a Scanner has be detected, then you can run this by hand to test.
# sudo simple-scan



 
