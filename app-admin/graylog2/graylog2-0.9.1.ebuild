# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Graylog2 system logger"

HOMEPAGE="http://www.graylog2.org/"

SRC_URI="http://github.com/downloads/lennartkoopmann/${PN}-server/${PN}-server-${PV}.tar.gz"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="dev-db/mongodb virtual/jdk"

S="${WORKDIR}/${PN}-server-${PV}"

MY_INSTALL="/usr/share/${PN}"
MY_CONF="${D}/etc/graylog2.conf"

src_install() { 
	dodir ${MY_INSTALL} || die "dodir failed"
	keepdir /var/log/graylog2

	# Copy dist files
	cp -r dist/{graylog2-server.jar,lib} "${D}/${MY_INSTALL}" || die "cp -r failed"

	# Copy conf
	dodir /etc
	cp graylog2.conf.example ${MY_CONF} > /dev/null 2>&1 || die "conf copy failed"
	chmod o-rwx ${MY_CONF} > /dev/null 2>&1 || die "chmod failed"

	# Init files
	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die "newconfd failed"

	dodoc dist/README.TXT build_date || die "dodoc failed"
}

pkg_preinst() {
	dosed "s:CHANGEME:${MY_INSTALL}:" "etc/conf.d/${PN}" || die "dosed failed"
}

pkg_postinst() {
	einfo "Please make sure to edit /etc/graylog2.conf to your needs"
}
