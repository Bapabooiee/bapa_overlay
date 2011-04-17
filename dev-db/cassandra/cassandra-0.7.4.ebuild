# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc"
EAPI=2

WANT_ANT_TASKS="ant-nodeps"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A highly scalable second-generation distributed database"
HOMEPAGE="http://cassandra.apache.org/"
SRC_URI="mirror://apache/cassandra/${PV}/apache-${P}-src.tar.gz"
S="${WORKDIR}/apache-${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6
	!dev-db/cassandra-bin"

pkg_setup() {
	enewgroup cassandra
	enewuser cassandra -1 -1 -1 cassandra
}

java_prepare() {
	rm "${S}/bin/"*.bat "${S}/bin/stop-server" || die "rm failed"
}

src_compile() {
	addwrite /root/.m2/
	java-pkg-2_src_compile
}

src_install() {

	# Binary scripts
	dobin bin/* || die "dobin failed"
	rm "${D}/usr/bin/cassandra.in.sh" || die "rm failed"

	insinto /usr/share/${PN}
	newins "${FILESDIR}/cassandra.in.sh" cassandra.in.sh || die "newins failed"

	# JAR libs
	java-pkg_dojar lib/*.jar || die "dojar failed"
	java-pkg_newjar build/apache-${P}-SNAPSHOT.jar ${PN}.jar || die "newjar failed"

	# Configs
	insinto /etc/cassandra
	doins conf/*.{properties,yaml,txt} || die "doins failed"
	newconfd "${FILESDIR}/conf_d_cassandra_07" cassandra || die "newconfd failed"
	cat conf/cassandra-env.sh | grep -v break >> ${D}/etc/conf.d/cassandra || die "cat/grep/>> failed"

	newinitd "${FILESDIR}/init_d_cassandra_07" cassandra || die "newinitd failed"

	# Runtime dirs needed
	keepdir /var/log/cassandra/ /var/lib/cassandra/commitlog /var/lib/cassandra/data /var/lib/cassandra/saved_caches || die "keepdir failed"

	chown -R cassandra:cassandra "${D}/var/lib/cassandra" "${D}/var/log/cassandra" || die "chown failed"

	# Docs
	dodoc CHANGES.txt LICENSE.txt NOTICE.txt NEWS.txt README.txt interface/cassandra.thrift || die "dodoc failed"
	docinto licenses
	dodoc lib/licenses/* || die "dodoc failed"
	use doc && (java-pkg_dojavadoc build/javadoc/ || die "dojavadoc failed")

}

pkg_postinst() {

	elog "Cassandra's configuration:"
	elog " * Run-time: /etc/cassandra/"
	elog " * Start-up: /etc/conf.d/cassandra"

	elog "Cassandra works best when the commitlog directory and the data directory are on different disks"
	elog "The default configuration sets them to /var/lib/cassandra/commitlog and /var/lib/cassandra/data respectively"
	elog "You may wish to change those to different mount points"

	ewarn "You should start/stop cassandra via /etc/init.d/cassandra, as this will properly switch to the cassandra:cassandra user group"
	ewarn "Starting cassandra via its default 'cassandra' shell command, as root, may cause permission problems later on when started as the cassandra user"

}
