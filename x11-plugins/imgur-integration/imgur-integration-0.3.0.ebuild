# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MY_P=imgur-${PV}

DESCRIPTION="A command-line utility & dbus service used to upload to imgur.com"
HOMEPAGE="https://github.com/tthurman/imgur-integration"
SRC_URI="http://spectrum.myriadcolours.com/~marnanel/${PN}/${MY_P}.tar.gz"
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

src_configure() {
	econf \
		$(use_enable eog)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS README || die "dodoc failed"
}

pkg_postinst() {
	if use eog; then
		elog "Please note that in order to use the eog plugin, you have"
		elog "to first enable it in [Edit -> Preferences -> Plugins]."
	fi
}
