EAPI=2

inherit eutils

MY_PN=${PN}-server
MY_P=${MY_PN}-${PV/_/}

DESCRIPTION="Daemon that forwards system logs to MongoDB databases"
HOMEPAGE="http://www.graylog2.org/"
SRC_URI="http://github.com/downloads/Graylog2/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="local-mongodb"

DEPEND="virtual/jdk"
RDEPEND="virtual/jre 
	local-mongodb? ( dev-db/mongodb )"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /etc
	newins graylog2.conf.example graylog2.conf || die "installing conf failed"
	fperms 600 /etc/graylog2.conf || die "fperms failed"

	insinto /usr/share/graylog2
	doins graylog2-server.jar || die "installing jar failed"

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN} || die "newinitd failed"

	if use local-mongodb; then
		sed -i \
			-e '/after logger/ a\\tneed mongodb' \
			"${D}"/etc/init.d/${PN} || die "sed failed"

		einfo "The \`local-mongodb' USE flag is set; a dependency for"
		einfo "MongoDB has been set in the init script."
	fi
}

pkg_postinst() {
	elog "Please note that graylog2 isn't a replacement for loggers"
	elog "such as syslog-ng or rsyslog. It listens on port 514, and"
	elog "forwards logs to a MongoDB database."
}
