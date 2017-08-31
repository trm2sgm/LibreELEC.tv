################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="Python3"
PKG_VERSION="3.6.2"
PKG_SHA256="9229773be41ed144370f47f0f626a1579931f5a390f1e8e3853174d52edd64a9"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.python.org/"
PKG_URL="http://www.python.org/ftp/python/$PKG_VERSION/${PKG_NAME::-1}-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME::-1}-$PKG_VERSION*"
PKG_DEPENDS_HOST="zlib:host bzip2:host"
PKG_DEPENDS_TARGET="toolchain sqlite expat zlib bzip2 openssl Python3:host"
PKG_SECTION="lang"
PKG_SHORTDESC="python: The Python programming language"
PKG_LONGDESC="Python is an interpreted object-oriented programming language, and is often compared with Tcl, Perl, Java or Scheme."

PKG_PYTHON_VERSION=3.6

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="ac_cv_prog_HAS_HG=/bin/false
                         ac_cv_prog_SVNVERSION=/bin/false
                         --disable-pyc-build
                         --disable-ossaudiodev
                         --disable-sqlite3
                         --disable-codecs-cjk
                         --disable-nis
                         --enable-unicodedata
                         --enable-openssl
                         --disable-readline
                         --disable-bzip2
                         --enable-zlib
                         --disable-xz
                         --disable-tk
                         --disable-curses
                         --disable-pydoc
                         --disable-test-modules
                         --enable-lib2to3
                         --disable-idle3
                         --without-cxx-main
                         --with-expat=builtin
                         --with-libmpdec=none
                         --with-doc-strings
                         --without-pymalloc
                         --without-ensurepi
"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_HAS_HG=/bin/false
                           ac_cv_prog_SVNVERSION=/bin/false
                           ac_cv_file__dev_ptmx=no
                           ac_cv_file__dev_ptc=no
                           ac_cv_have_long_long_format=yes
                           ac_cv_working_tzset=yes
                           ac_cv_func_lchflags_works=no
                           ac_cv_func_chflags_works=no
                           ac_cv_func_printf_zd=yes
                           ac_cv_buggy_getaddrinfo=no
                           ac_cv_header_bluetooth_bluetooth_h=no
                           ac_cv_header_bluetooth_h=no
                           --disable-pyc-build
                           --disable-ossaudiodev
                           --enable-sqlite3
                           --disable-codecs-cjk
                           --disable-nis
                           --enable-unicodedata
                           --enable-openssl
                           --disable-readline
                           --enable-bzip2
                           --enable-zlib
                           --disable-xz
                           --disable-tk
                           --disable-curses
                           --disable-pydoc
                           --disable-test-modules
                           --disable-lib2to3
                           --disable-idle3
                           --without-cxx-main
                           --with-expat=system
                           --with-libmpdec=none
                           --with-doc-strings
                           --without-pymalloc
                           --without-ensurepip
                           --with-threads
                           --enable-ipv6
"

post_unpack() {
  # This is needed to make sure the Python build process doesn't try to
  # regenerate those files with the pgen program. Otherwise, it builds
  # pgen for the target, and tries to run it on the host.
    touch $PKG_BUILD/Include/graminit.h
    touch $PKG_BUILD/Python/graminit.c
}

post_makeinstall_host() {
  rm -f $TOOLCHAIN/bin/python*-config
  rm -f $TOOLCHAIN/bin/smtpd.py*
  rm -f $TOOLCHAIN/bin/pyvenv
  rm -f $TOOLCHAIN/bin/pydoc*

  # Ensure python -> python3, as Python3 is now the default python
  ln -sf python3 $TOOLCHAIN/bin/python
}

post_makeinstall_target() {
  PYTHON_VER=$(get_pkg_variable Python3 PKG_PYTHON_VERSION)
  PYTHON_PATH_LIB=/usr/lib/python$PYTHON_VER

  EXCLUDE_DIRS="config compiler sysconfigdata lib-dynload/sysconfigdata lib2to3 test"
  for dir in $EXCLUDE_DIRS; do
    rm -rf $INSTALL$PYTHON_PATH_LIB/$dir
  done

  rm -rf $INSTALL/usr/bin/2to3
  rm -rf $INSTALL/usr/bin/idle
  rm -rf $INSTALL/usr/bin/pydoc
  rm -rf $INSTALL/usr/bin/pyenv
  rm -rf $INSTALL/usr/bin/smtpd.py INSTALL/usr/bin/smtpd.py.*
  rm -rf $INSTALL/usr/bin/python*-config
  ln -sf /usr/bin/python3 $INSTALL/usr/bin/python

  cd $INSTALL$PYTHON_PATH_LIB
  $TOOLCHAIN/bin/python3 -Wi -t -B $PKG_BUILD/Lib/compileall.py -d $PYTHON_PATH_LIB -b -f .
  find $INSTALL$PYTHON_PATH_LIB -name "*.py" -exec rm -f {} \; &>/dev/null

  # strip
  chmod u+w $INSTALL/usr/lib/libpython*.so.*
  debug_strip $INSTALL/usr

  # python always points to python3
  ln -sf /usr/bin/python3 $INSTALL/usr/bin/python
}
