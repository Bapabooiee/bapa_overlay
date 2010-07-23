# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Yaws is a high performance HTTP 1.1 web server."
HOMEPAGE="http://yaws.hyber.org/"
SRC_URI="http://yaws.hyber.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND="dev-lang/erlang"

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
}

pkg_preinst() {
	local CONF="${D}/etc/yaws/yaws.conf"

	sed -i \
		"s:/usr/var/log/yaws:/var/log/yaws:" \
		${CONF}
	
#	if use amd64; then
#		sed -i \
#			"s:/lib/:/lib64/:" \
#			${CONF}
#	fi
}

pkg_postinst() {
	einfo "Please make sure to edit /etc/yaws/yaws.conf to suit your needs."
}
