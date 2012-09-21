EAPI=4

inherit eutils

DESCRIPTION="ElasticSearch is a database for real-time search"
HOMEPAGE="http://www.elasticsearch.org/"
SRC_URI="http://cloud.github.com/downloads/elasticsearch/elasticsearch/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/jre"

ROOT_DIR=/opt/${PN}

pkg_setup() {
	enewgroup elasticsearch 764
	enewuser elasticsearch 764  -1 /dev/null elasticsearch
}

src_prepare() {
	rm -f "${S}"/lib/sigar/*{freebsd,macosx,solaris,winnt,ia64}* > /dev/null 2>&1
}

src_install() {
	insinto ${ROOT_DIR}
	exeinto ${ROOT_DIR}/bin

	doins -r lib
	doexe bin/*
	make_wrapper ${PN} ${ROOT_DIR}/bin/${PN} "" "" /opt/bin

	insinto /etc/${PN}
	doins config/*

	#cat > 99${PN} <<-EOF
		#CONFIG_PROTECT="${ROOT_DIR}/config"
	#EOF
	#doenvd 99${PN} 99${PN}

	for i in lib log run; do
		keepdir /var/${i}/${PN}
		fowners elasticsearch:elasticsearch /var/${i}/${PN}
	done

	fperms 750 /etc/${PN} /var/{lib,log}/${PN}
	
	dosym /etc/${PN} ${ROOT_DIR}/config
	dosym /var/lib/${PN} ${ROOT_DIR}/data
	dosym /var/log/${PN} ${ROOT_DIR}/logs

	newinitd "${FILESDIR}"/${PN}-initd ${PN}

	# TODO: Add /etc/logrotate.d entry
}
