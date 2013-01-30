EAPI=4

inherit eutils
DESCRIPTION="Data-collection and graphing for Nagios"
HOMEPAGE="http://nagiosgraph.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl net-analyzer/nagios"

src_install() {
	dodir /opt/${PN}

	insinto /opt/${PN}
	doins -r lib share

	exeinto /opt/${PN}/lib ; doexe lib/*
	exeinto /opt/${PN}/cgi ; doexe cgi/*

	cat > "${T}"/50${PN} <<-EOF
		CONFIG_PROTECT="/opt/${PN}/etc"
	EOF
	doenvd "${T}"/50${PN}

	dodoc -r AUTHORS CHANGELOG INSTALL README TODO examples

	dodir /etc/opt/${PN}
	insinto /etc/opt/${PN}
	doins -r etc/*

	dosym /etc/opt/${PN} /opt/${PN}/etc
}
