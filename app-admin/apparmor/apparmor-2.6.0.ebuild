# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools versionator

MY_VER=$(get_version_component_range 1-2)

DESCRIPTION="Userspace utilties for AppArmor"
HOMEPAGE="https://launchpad.net/apparmor/"
SRC_URI="http://launchpad.net/${PN}/${MY_VER}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls python ruby"

# TODO: Add deps
DEPEND=""
RDEPEND="${DEPEND}"

ARMOR_DIR=${S}/libraries/libapparmor
UTIL_DIR=${S}/utils

src_prepare() {
	cd "${ARMOR_DIR}"
	eautoreconf
}

src_configure() {
	cd "${ARMOR_DIR}"

	# Perl makes the build explode; will fix later
	econf \
		--without-perl
		$(use_with python) \
		$(use_with ruby) \
		#$(use_with perl)
}

src_compile() {
	cd "${ARMOR_DIR}"
	emake
}

src_install() {
	cd "${ARMOR_DIR}"
	make install DESTDIR="${D}"

	cd "${UTIL_DIR}"
	make install DESTDIR="${D}"

	if ! use nls; then
		rm -rf "${D}"/usr/share/locale
	fi
}
