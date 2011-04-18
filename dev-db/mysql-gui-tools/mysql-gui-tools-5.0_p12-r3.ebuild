# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-gui-tools/Attic/mysql-gui-tools-5.0_p12-r3.ebuild,v 1.3 2010/04/11 20:51:24 swegener dead $

GCONF_DEBUG="no"
EAPI="1"

inherit autotools gnome2 eutils flag-o-matic

MY_P="${P/_p/r}"

DESCRIPTION="MySQL GUI Tools"
HOMEPAGE="http://www.mysql.com/products/tools/"
SRC_URI="mirror://mysql/Downloads/MySQLGUITools/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls +administrator +query-browser"

RDEPEND=">=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.6
	>=gnome-base/libglade-2.5
	>=dev-libs/libsigc++-2.0
	>=dev-libs/libpcre-4.4
	>=dev-libs/libxml2-2.6.2
	>=dev-cpp/glibmm-2.14
	dev-cpp/gtkmm:2.4
	>=virtual/mysql-5.0
	query-browser? (
		gnome-extra/gtkhtml:3.14
		gnome-base/libgnomeprint:2.2
		gnome-base/libgnome
	)"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15
	>=app-text/scrollkeeper-0.3.11"
RDEPEND="${RDEPEND}
	!dev-db/mysql-administrator
	!dev-db/mysql-query-browser"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	if ! use administrator && ! use query-browser
	then
		elog "Please activate at least one of the following USE flags:"
		elog "- administrator for MySQL Administrator"
		elog "- query-browser for MySQL Query Browser"
		die "Please activate at least one of the following USE flags: administrator, query-browser"
	fi

	# Needed for gcc-4.3
	append-cppflags -D_GNU_SOURCE
}

src_unpack() {
	gnome2_src_unpack
	cd "${S}"

	epatch \
		"${FILESDIR}"/${PN}-5.0_p8-i18n-fix.patch \
		"${FILESDIR}"/${PN}-5.0_p8-lua-modules.patch \
		"${FILESDIR}"/${P}-query-browser-sps.patch \
		"${FILESDIR}"/${P}-libsigc++-2.2.patch \
		"${FILESDIR}"/${P}-gcc-4.3.patch \
		"${FILESDIR}"/${P}-deprecated-gtk+-api.patch \
		"${FILESDIR}"/${P}-gnome-2.28.patch \
		"${FILESDIR}"/${P}-gtk-widgetstate.patch

	sed -i \
		-e "s/\\(^\\|[[:space:]]\\)-ltermcap\\($\\|[[:space:]]\\)/ /g" \
		mysql-gui-common/tools/grtsh/Makefile.{am,in}

	if use query-browser
	then
		cd "${S}"/mysql-query-browser
		eautoreconf
	fi
}

src_compile() {
	# mysql has -fno-exceptions, but we need exceptions
	append-flags -fexceptions

	cd "${S}"/mysql-gui-common
	use nls || sed -i -e "/^SUBDIRS = / s/\\bpo\\b//" Makefile.{am,in}
	gnome2_src_compile \
		--disable-java-modules \
		--disable-workbench \
		$(use_enable nls i18n)

	if use administrator
	then
		cd "${S}"/mysql-administrator
		use nls || sed -i -e "/^SUBDIRS = / s/\\bpo\\b//" Makefile.{am,in}
		gnome2_src_compile $(use_enable nls i18n)
	fi

	if use query-browser
	then
		cd "${S}"/mysql-query-browser
		use nls || sed -i -e "/^SUBDIRS=/ s/\\bpo\\b//" Makefile.{am,in}
		gnome2_src_compile --with-gtkhtml=libgtkhtml-3.14
	fi
}

src_install() {
	cd "${S}"/mysql-gui-common
	gnome2_src_install

	if use administrator
	then
		cd "${S}"/mysql-administrator
		gnome2_src_install
	fi

	if use query-browser
	then
		cd "${S}"/mysql-query-browser
		gnome2_src_install
	fi
}
