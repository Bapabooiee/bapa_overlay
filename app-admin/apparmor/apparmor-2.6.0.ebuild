# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PERL_EXPORT_PHASE_FUNCTIONS="no"

inherit eutils autotools versionator perl-module linux-info

MY_VER=$(get_version_component_range 1-2)

DESCRIPTION="Userspace utilties for AppArmor"
HOMEPAGE="https://launchpad.net/apparmor/"
SRC_URI="http://launchpad.net/${PN}/${MY_VER}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="nls pam python ruby"
IUSE="nls pam"

# TODO: Add deps
DEPEND=""
RDEPEND="${DEPEND}"

CONFIG_CHECK="~SECURITY_APPARMOR"
MAKEOPTS="${MAKEOPS} -j1" # explodes with parallel make

# TODO: Figure out how to avoid all this boilerplate code

pkg_setup() {
	perl-module_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	cd "${S}"/libraries/libapparmor
	eautoreconf
}

src_configure() {
	cd "${S}"/libraries/libapparmor
	econf \
		--with-perl
		#$(use_with python) \
		#$(use_with ruby)
}

src_compile() {
	cd "${S}"/libraries/libapparmor ; emake
	cd "${S}"/utils ; emake

	if use pam; then
		cd "${S}"/changehat/pam_apparmor ; emake
	fi
}

src_install() {
	[ -f README ] && dodoc README

	cd "${S}"/libraries/libapparmor
	emake install DESTDIR="${D}"

	cd "${S}"/utils
	emake install DESTDIR="${D}" PERLDIR="${D}/${VENDOR_ARCH}/Immunix"

	if use pam; then
		cd "${S}"/changehat/pam_apparmor
		emake install DESTDIR="${D}"
	fi

	# Should probably be a LINGUAS variable
	if ! use nls; then
		rm -rf "${D}"/usr/share/locale
	fi
}
