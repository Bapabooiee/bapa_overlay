# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgmemcache/pgmemcache-2.0.6.ebuild,v 1.2 2011/06/06 14:42:24 mr_bones_ Exp $

EAPI=4

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache"
SRC_URI="http://pgfoundry.org/frs/download.php/3018/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-base-8.4
	dev-libs/cyrus-sasl
	>=dev-libs/libmemcached-0.39"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	einfo "Re-packaging as an extension ..."

	cat > ${PN}.control <<-END
		comment = '${PN} extension'
		default_version = '1.0'
		module_pathname = '\$libdir/${PN}'
		relocatable = true
	END

	# Remove the search_path, since we want to be relocatable.
	sed -i ${PN}.sql.in \
		-e '/^SET search_path/s/^/--/' \
		-e "s/'C'/C/" || die "sed failed"

	mv ${PN}.sql.in ${PN}--1.0.sql || die "mv failed"

	# Tell Makefile we're packaging an extension.
	sed -i \
		-e "1i EXTENSION = ${PN}" \
		-e 's/$(MODULE_big).sql/$(MODULE_big)--1.0.sql/' \
		-e 's/DATA_built/DATA/' Makefile || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README NEWS test.sql
	dohtml README.html
}
