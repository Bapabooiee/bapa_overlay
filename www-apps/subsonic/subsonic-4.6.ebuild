# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils java-pkg-2

DESCRIPTION="Subsonic is a web-based media streamer"
HOMEPAGE="http://www.subsonic.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="source"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	dev-java/maven-bin:2.2
	source? ( app-arch/zip )"

SUBSONIC_DIR="/var/subsonic"

S=${WORKDIR}

pkg_setup() {
	java-pkg-2_pkg_setup

	echo
	ewarn "If this is your first time emerging Subsonic, you"
	ewarn "might have to wait for Maven to download some extra"
	ewarn "support files. They will be in /var/tmp/portage/.m2/"
	ewarn
	ewarn "It could take quite a while, so please be patient."
	echo

	echo
	ewarn "*******************"
	ewarn "If Subsonic fails to build due to some permission problems,"
	ewarn "it's likely due to not having \"userpriv\" and \"usersandbox\" set"
	ewarn "in Portage's FEATURES variable."
	ewarn
	ewarn "Please see man (5) make.conf, and make sure they are set."
	ewarn "*******************"
	echo


}

src_compile() {
	mvn-2.2 install -DskipTests || die "mvn failed"
}

src_install() {
	cd subsonic-main

	java-pkg_dowar target/${PN}.war

	dodoc README.TXT || die "dodoc failed"
	newdoc "Getting Started.html" getting_started.html || die "newdoc failed"

	if use source; then
		java-pkg_dosrc src/*
	fi
}

pkg_postinst() {
	echo
	elog "In order to use ${PN}, you must have a Java Applet Server such"
	elog "as www-servers/tomcat installed."
	elog
	elog "As an example, to deploy ${PN} on tomcat, just copy ${PN}.war into"
	elog "/var/lib/tomcat-*/webapps, or browse to http://localhost:8080/manager/html"
	elog "and deploy it from there."
	echo
	elog "Please also note that ${SUBSONIC_DIR} must exist and be owned by"
	elog "the server user (eg, tomcat) in order for Subsonic to work."
	echo
}
