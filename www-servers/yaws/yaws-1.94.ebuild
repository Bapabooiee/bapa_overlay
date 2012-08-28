# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib

DESCRIPTION="Yaws is a high performance HTTP 1.1 web server"
HOMEPAGE="http://yaws.hyber.org/"
SRC_URI="http://yaws.hyber.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="munin"

DEPEND="dev-lang/erlang"
RDEPEND="${DEPEND}
	munin? ( net-analyzer/munin )"

PROVIDE="virtual/httpd-basic virtual/httpd-cgi"

src_prepare() {
	# The Makefile in doc/ is buggy, so skip it
	sed -i \
		-e "2s/ doc//" \
		"${S}"/Makefile || die "dosed doc/ failed"
}

src_install() {
	emake DESTDIR=${D} install

	keepdir /var/log/yaws
	rmdir "${D}"var/lib/log/yaws
	rmdir "${D}"var/lib/log

	# We need to keep these directories so that the example yaws.conf works
	# properly
	keepdir /usr/lib/yaws/examples/ebin \
		/usr/lib/yaws/examples/include
	dodoc ChangeLog LICENSE README

	local myconf=${D}/etc/${PN}/${PN}.conf

	# This should probably be in src_prepare
	sed -i \
		-e "s:/usr/var/log/yaws:/var/log/yaws:" \
		-e "s:/usr/lib/:/usr/$(get_libdir)/:" \
		-e "s:/tmp:/var/www/localhost/htdocs:" \
		${myconf} || die "sed failed"


	if use munin; then
		dodoc munin/README.munin

		exeinto /usr/libexec/munin/plugins
		doexe munin/yaws_{hits,sent}_
	fi
}
