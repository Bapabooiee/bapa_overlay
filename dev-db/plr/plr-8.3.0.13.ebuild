# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="R language addon for postgresql database"
HOMEPAGE="http://www.joeconway.com/plr/"
SRC_URI="http://www.joeconway.com/plr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/R
	>=dev-db/postgresql-server-8.3"
DEPEND="${RDEPEND}"

S=${WORKDIR}/contrib/${PN}

src_unpack() {
	unpack ${A}
	# the build system wants 'contrib' to be part of the path
	mkdir "${WORKDIR}/contrib"
	mv "${WORKDIR}/${PN}" "${S}"
}

src_prepare() {
	sed -i \
		-e "s/'C'/C/g" \
		${PN}--${PV}.sql || die "sed failed"
}

src_compile() {
	USE_PGXS=1 emake -j1
}

src_install() {
	USE_PGXS=1 emake -j1 DESTDIR="${D}" install
}

pkg_postinst() {
	elog "PL/R has been built against the currently eselected version of PostgreSQL."
	ewarn "If you want to install PL/R for other versions of postgres, please use eselect"
	ewarn "to select the other version and then re-emerge this package."
	elog "For instructions on how to add PL/R to your postgresql database(s), please visit"
	elog "http://www.joeconway.com/plr/doc/plr-install.html"
}
