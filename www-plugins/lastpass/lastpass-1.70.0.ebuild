# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit multilib mozextension

MY_P=${P}-fx
MY_XPI="${MY_P}+tb+sm+fn-linux"

DESCRIPTION="LastPass is a secure, cross-platform, cross-browser online password manager"
HOMEPAGE="http://lastpass.com/"
SRC_URI="http://releases.mozilla.org/pub/mozilla.org/addons/8542/${MY_XPI}.xpi"
RESTRICT="strip"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| (
	>=www-client/firefox-2.0.0 
	>=www-client/firefox-bin-2.0.0
)"

S=${WORKDIR}/${MY_XPI}

src_unpack() {
	xpi_unpack "${DISTDIR}"/${MY_XPI}.xpi
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

