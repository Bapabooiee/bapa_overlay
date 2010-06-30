# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils autotools
DESCRIPTION="Pidgin Xfire plugin"

HOMEPAGE="http://gfireproject.org/"
SRC_URI="http://cdnetworks-us-1.dl.sourceforge.net/project/gfire/gfire/gfire-0.9.2/pidgin-gfire-0.9.2.tar.bz2"

LICENSE=""

SLOT="0"

KEYWORDS="amd64 x86"

IUSE=""

DEPEND="net-im/pidgin"
RDEPEND="${DEPEND}"

src_configure() {
	econf || die "econf failed"
}

src_compile() { 
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYING README NEWS VERSION ChangeLog || die "dodoc failed"
}
