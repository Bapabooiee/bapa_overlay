# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Pidgin plugin for adding Xfire accounts and connecting to the Xfire network"
HOMEPAGE="http://gfireproject.org/"
SRC_URI="mirror://sourceforge/gfire/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug dbus gtk libnotify nls"

RDEPEND="
	>=net-im/pidgin-2.5.0[gtk?]
	dbus? ( dev-libs/dbus-glib )
	gtk? ( x11-libs/gtk+:2 )
	libnotify? ( x11-libs/libnotify )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	local myconf=$(use_enable libnotify)

	if use libnotify && ! use gtk; then
		ewarn "libnotify requires GTK support to be enabled; libnotify disabled"
		myconf="--disable-libnotify"
	fi

	econf \
		$(use_enable dbus dbus-status) \
		$(use_enable debug) \
		$(use_enable gtk) \
		$(use_enable nls) \
		${myconf}
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS README NEWS VERSION ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	elog "Please note that Pidgin must first be restarted before"
	elog "you'll be able to add your Xfire accounts"
}
