# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools versionator linux-info

MY_VER=$(get_version_component_range 1-2)

DESCRIPTION="Userspace utilties for AppArmor"
HOMEPAGE="https://launchpad.net/apparmor/"
SRC_URI="http://launchpad.net/${PN}/${MY_VER}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls pam perl python ruby"

# TODO: Add deps
DEPEND=""
RDEPEND="${DEPEND}"

CONFIG_CHECK="~SECURITY_APPARMOR"

# TODO: Figure out how to avoid all this boilerplate code

src_prepare() {
	cd "${S}"/libraries/libapparmor
	eautoreconf
}

src_configure() {
	cd "${S}"/libraries/libapparmor
	econf \
		$(use_with perl) \
		$(use_with python) \
		$(use_with ruby)
}

src_compile() {
	cd "${S}"/libraries/libapparmor ; emake
	cd "${S}"/utils ; emake

	if use pam; then
		cd "${S}"/changehat/pam_apparmor ; emake
	fi
}

src_install() {
	dodoc README

	cd "${S}"/libraries/libapparmor
	emake install DESTDIR="${D}"

	cd "${S}"/utils
	emake install DESTDIR="${D}"

	if use pam; then
		cd "${S}"/changehat/pam_apparmor
		emake install DESTDIR="${D}"
	fi

	# Should probably be a LINGUAS variable
	if ! use nls; then
		rm -rf "${D}"/usr/share/locale
	fi
}
