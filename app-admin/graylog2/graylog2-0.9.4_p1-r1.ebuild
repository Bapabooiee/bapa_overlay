EAPI=2

MY_PN=${PN}-server
MY_P=${MY_PN}-${PV/_/}

DESCRIPTION="Daemon that forwards system logs to MongoDB databases"
HOMEPAGE="http://www.graylog2.org/"
SRC_URI="http://github.com/downloads/Graylog2/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/jdk"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /etc
	newins graylog2.conf.example graylog2.conf || die "installing conf failed"
	fperms 600 /etc/graylog2.conf || die "fperms failed"

	insinto /usr/share/graylog2
	doins graylog2-server.jar || die "installing jar failed"

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN} || die "newinitd failed"
}

pkg_postinst() {
	elog "Please make sure to edit /etc/graylog2.conf to your needs"
	elog
	elog "Please remember to configure your system lo"
}
