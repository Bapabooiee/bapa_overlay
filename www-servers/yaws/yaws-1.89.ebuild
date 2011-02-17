# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib

DESCRIPTION="Yaws is a high performance HTTP 1.1 web server."
HOMEPAGE="http://yaws.hyber.org/"
SRC_URI="http://yaws.hyber.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/erlang"
RDEPEND="${DEPEND}"

PROVIDE="virtual/httpd-basic virtual/httpd-cgi"

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	keepdir /var/log/yaws
	rmdir ${D}var/lib/log/yaws
	rmdir ${D}var/lib/log
	# We need to keep these directories so that the example yaws.conf works
	# properly
	keepdir /usr/lib/yaws/examples/ebin
	keepdir /usr/lib/yaws/examples/include
	dodoc ChangeLog LICENSE README

	local myconf="${D}/etc/${PN}/${PN}.conf"

	sed -i \
		-e "s:/usr/var/log/yaws:/var/log/yaws:" \
		-e "s:/usr/lib/:/usr/$(get_libdir)/:" \
		-e "s:/tmp:/var/www/localhost/htdocs:" \
		${myconf} || die "sed failed"
}
