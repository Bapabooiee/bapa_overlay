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

src_install() { 
	dodir /etc; insinto /etc
	newins graylog2.conf.example graylog2.conf || die "installing conf failed"
	fperms 660 /etc/graylog2.conf || die "fperms failed"

	dodir ${MY_INSTALL} || die "dodir failed"
	insinto ${MY_INSTALL} || die "insinto failed"

	cd dist
	doins graylog2-server.jar || die "installing jar failed"
	doins -r lib || die "installing -r lib failed"

	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die "newconfd failed"

	dodoc README.TXT ../build_date || die "dodoc failed"

	keepdir "/var/log/${PN}" || die "keepdir failed"
}

pkg_preinst() {
	dosed "s:CHANGEME:${MY_INSTALL}:" "etc/conf.d/${PN}" || die "dosed failed"
}

pkg_postinst() {
	elog "Please make sure to edit /etc/graylog2.conf to your needs"
}
