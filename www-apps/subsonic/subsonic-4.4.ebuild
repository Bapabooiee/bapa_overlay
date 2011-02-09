# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils java-pkg-2

DESCRIPTION="Subsonic is a web-based media streamer"
HOMEPAGE="http://www.subsonic.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="source tomcat-deploy"

RDEPEND=">=virtual/jre-1.5
	tomcat-deploy? ( www-servers/tomcat:6 )"
DEPEND=">=virtual/jdk-1.5
	dev-java/maven-bin:2.2
	source? ( app-arch/zip )"

SUBSONIC_DIR="/var/subsonic"

S=${WORKDIR}

src_prepare() {
	java-pkg-2_src_prepare
	mv subsonic-main/{"Getting Started",getting_started}.html || die "mv html failed"
}

src_compile() {
	mvn install -DskipTests || die "mvn failed"
}

src_install() {
	cd subsonic-main

	java-pkg_dowar target/subsonic.war

	dodoc getting_started.html README.TXT || die "dodoc failed"

	if use source; then
		java-pkg_dosrc src/*
	fi
}

pkg_postinst() {
	if use tomcat-deploy; then
		local tomcatdir=/var/lib/tomcat-6/webapps

		if [ ! -d ${SUBSONIC_DIR} ]; then
			einfo "Creating directory ${SUBSONIC_DIR} ..."

			mkdir ${SUBSONIC_DIR} || die "mkdir ${SUBSONIC_DIR} failed"
			chown -R tomcat:tomcat ${SUBSONIC_DIR} || die "chown ${PN} failed"

			if [ ! -d ${tomcatdir}/${PN} ]; then
				einfo "Copying subsonic.war to ${tomcatdir}/ ..."

				cp /usr/share/${PN}/webapps/${PN}.war ${tomcatdir} || die "cp tomcat.war failed"
				chown tomcat:tomcat ${tomcatdir}/${PN}.war || die "chown tomcat.war failed"

				echo ""
				elog "If everything went smoothly, you should now be able to point"
				elog "your browser to http://localhost:8080/subsonic."
			else
				echo ""
				elog "It seems ${PN} is already deployed; not copying ${PN}.war"
				echo ""
			fi
		else
			elog "${SUBSONIC_DIR} exists; not touching anything."
			echo ""
		fi
	fi

	elog "Please note that ${SUBSONIC_DIR} must exist and be owned by"
	elog "the server user (eg, tomcat) in order for Subsonic to work."
}
