# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Tray applet that lets you create and mount EncFS volumes"
HOMEPAGE="http://tom.noflag.org.uk/cryptkeeper.html"
SRC_URI="http://tom.noflag.org.uk/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

RDEPEND=">=gnome-base/gconf-2.26.2
	>=sys-fs/encfs-1.7.2
	>=sys-fs/fuse-2.8.0
	>=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}" || die
}
