# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="mount tar archives using fuse"
HOMEPAGE="http://en.wikipedia.org/wiki/Archivemount"
SRC_URI="http://www.cybernoia.de/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="app-arch/libarchive
		 sys-fs/fuse"
DEPEND="${RDEPEND}"

src_configure() {
	econf || die "conf failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc CHANGELOG COPYING README || die "dodoc failed"
}

