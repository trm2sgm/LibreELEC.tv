################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="bash"
PKG_VERSION="4.4"
PKG_SHA256="d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/bash/bash.html"
PKG_URL="https://ftp.gnu.org/gnu/bash/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_SECTION="devel"
PKG_SHORTDESC="The GNU Bourne Again shell"
PKG_LONGDESC="The GNU Bourne Again shell"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline"

pre_configure_target() {
  export LIBS="-lterminfo"
}
