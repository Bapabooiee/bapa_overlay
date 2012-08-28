EAPI=2

inherit eutils

MY_PN=${PN}-server
MY_P=${MY_PN}-${PV/_/}

DESCRIPTION="Daemon that forwards system logs to ElasticSearch databases"
HOMEPAGE="http://www.graylog2.org/"
SRC_URI="http://github.com/downloads/Graylog2/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jdk"
RDEPEND="virtual/jre"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /etc
	newins graylog2.conf.example graylog2.conf || die "installing conf failed"
	fperms 600 /etc/graylog2.conf || die "fperms failed"

	insinto /usr/share/graylog2
	doins graylog2-server.jar || die "installing jar failed"

	newinitd "${FILESDIR}/${PN}-0.9.6.initd" ${PN} || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}-0.9.6.confd" ${PN} || die "newconfd failed"
}

pkg_postinst() {
	ewarn "Please note that support for MongoDB in Graylog2 is going away"
	ewarn "soon, in favor of ElasticSearch <http://www.elasticsearch.org>."
	ewarn ""
	ewarn "For the time being, MongoDB will still work and can be used in tandem"
	ewarn "with ES. If you want to disable using MongoDB, you can comment-out all the"
	ewarn "MongoDB-related lines in the config file. However, using ES is NOT optional."
}
