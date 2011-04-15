# Copyright 1999-2011 Gentoo Foundation
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

	if ! hasq userpriv "${FEATURES}" || ! hasq usersandbox "${FEATURES}"; then
		eerror "Due to the sad state of Maven in Portage, you *must* set"
		eerror "\"userpriv\" and \"usersandbox\" in FEATURES in order for"
		eerror "this ebuild to work."
		eerror
		eerror "See FEATURES in man(5) make.conf."
		eerror

		die "userpriv and usersandbox must be set in FEATURES"
	fi

	echo
	ewarn
	ewarn "If this is your first time emerging ${PN}, you"
	ewarn "might have to wait for Maven to download some extra"
	ewarn "support files."
	ewarn
	ewarn "It could take a while, so please be patient."
	ewarn
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
