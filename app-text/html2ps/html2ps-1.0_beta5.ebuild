# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV=${PV/_beta/b}

DESCRIPTION="HTML-to-PostScript converter"
HOMEPAGE="http://user.it.uu.se/~jan/html2ps.html"
SRC_URI="http://user.it.uu.se/~jan/${PN}-${MY_PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="tcltk"


DEPEND="dev-lang/perl
	tcltk? ( dev-lang/tk )"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	epatch "${FILESDIR}/${P}-conf.patch"
	epatch "${FILESDIR}/${P}-perl.patch"
}

src_install () {
	dobin html2ps || die "dobin failed"

	doman html2ps.1 || die "doman failed"
	dodoc README html2ps.html sample || die "dodoc failed"

	#insinto /etc; doins html2psrc || die "doins html2psrc failed"

	if use tcltk; then
		dobin contrib/xhtml2ps/xhtml2ps || die "tcltk dobinf ailed"
		newdoc contrib/xhtml2ps/README README.xhtml2ps || die "tcltk newdoc failed"
	fi
}
