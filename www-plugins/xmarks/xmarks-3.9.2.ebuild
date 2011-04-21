# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit multilib mozextension

MY_P=${P}-fx

DESCRIPTION="Xmarks is a cross-platform, cross-browser bookmark sync service"
HOMEPAGE="http://www.xmarks.com/"
SRC_URI="http://releases.mozilla.org/pub/mozilla.org/addons/2410/${MY_P}.xpi"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| (
	>=www-client/firefox-3.0.0 
	>=www-client/firefox-bin-3.0.0
)"

S=${WORKDIR}/${MY_P}

src_unpack() {
	xpi_unpack "${DISTDIR}"/${MY_P}.xpi
}

src_install() {
	local MOZILLA_FIVE_HOME=

	if has_version 'www-client/firefox'; then
		MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"
		xpi_install .
	fi
	if has_version "www-client/firefox-bin"; then
		MOZILLA_FIVE_HOME="/opt/firefox"
		xpi_install .
	fi
}

