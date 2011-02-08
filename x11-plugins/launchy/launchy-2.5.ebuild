# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils qt4-r2

DESCRIPTION="A keystroke-based program launcher, similar to gnome-do"
HOMEPAGE="http://www.launchy.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"
