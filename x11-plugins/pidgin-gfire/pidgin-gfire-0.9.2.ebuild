# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Pidgin Xfire plugin"

HOMEPAGE="http://gfireproject.org/"
SRC_URI="http://cdnetworks-us-1.dl.sourceforge.net/project/gfire/gfire/gfire-${PV}/${P}.tar.bz2"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="amd64 x86"

IUSE=""

DEPEND="net-im/pidgin"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYING README NEWS VERSION ChangeLog || die "dodoc failed"
}
