# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MY_PN=imgur
MY_P=${MY_PN}-${PV}

if [[ ${PV} == "9999" ]]; then
	inherit git autotools
	EGIT_REPO_URI="https://github.com/tthurman/imgur-integration.git"
	SRC_URI=""
else
	SRC_URI="http://spectrum.myriadcolours.com/~marnanel/${PN}/${MY_P}.tar.gz"
fi

DESCRIPTION="A command-line utility & dbus service used to upload to imgur.com"
HOMEPAGE="https://github.com/tthurman/imgur-integration"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"
IUSE="eog"

DEPEND="sys-apps/dbus
	>=dev-libs/dbus-glib-0.88	
	>=dev-libs/glib-2.24
	eog? ( media-gfx/eog )
	net-misc/curl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	if [[ ${PV} == "9999" ]]; then
		mkdir m4; eautoreconf -i
	fi
}

src_configure() {
	econf \
		$(use_enable eog)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake failed"
	dodoc AUTHORS README || die "dodoc failed"
}

pkg_postinst() {
	if use eog; then
		elog "Please note that in order to use the eog plugin, you have"
		elog "to first enable it in [Edit -> Preferences -> Plugins]."
	fi
}