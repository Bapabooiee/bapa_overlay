EAPI="3"

inherit eutils

MY_PN=${PN}-server
MY_P=${MY_PN}-${PV}

GL2_INSTALL=/usr/share/${PN}

DESCRIPTION="Graylog2 system logger"
HOMEPAGE="http://www.graylog2.org/"
SRC_URI="http://github.com/downloads/lennartkoopmann/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-db/mongodb virtual/jdk"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /etc
	newins graylog2.conf.example graylog2.conf || die "installing conf failed"
	fperms 660 /etc/graylog2.conf || die "fperms failed"

	insinto ${GL2_INSTALL}

	cd dist
	doins graylog2-server.jar || die "installing jar failed"
	doins -r lib || die "installing -r lib failed"

	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die "newconfd failed"

	dodoc README.TXT ../build_date || die "dodoc failed"

	keepdir /var/log/${PN} || die "keepdir failed"
}

pkg_preinst() {
	dosed "s:CHANGEME:${GL2_INSTALL}:" "etc/conf.d/${PN}" || die "dosed failed"
}

pkg_postinst() {
	elog "Please make sure to edit /etc/graylog2.conf to your needs"
}
