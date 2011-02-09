# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils java-pkg-2

DESCRIPTION="Herp derp"
HOMEPAGE="http://www.subsonic.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="source"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	dev-java/maven-bin:2.2
	source? ( app-arch/zip )"

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
