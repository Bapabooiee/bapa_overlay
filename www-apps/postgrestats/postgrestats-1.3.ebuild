# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A web front-end for usefully exposing PostgreSQL statistics"
HOMEPAGE="http://www.postgrestats.com"
SRC_URI="http://www.postgrestats.com/release/${PV}/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/php"

S="${WORKDIR}"/${PN}

src_prepare() {
	einfo "Removing junk files ..."
	find "${S}" \( -name '.*DS_Store*' -o -name '.?*' \) -execdir rm '{}' \; || die "find rm failed"
}

src_install() {
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	
	doins -r index.php scripts graphics
	dodoc copying.txt installation.txt readme.txt version.txt
}

pkg_postinst() {
	elog "Please note that this ebuild/package does not use Gentoo's \`webapp-config',"
	elog "so you will need to copy /usr/share/${PN} to another directory and make your"
	elog "local config modifications there."
}
