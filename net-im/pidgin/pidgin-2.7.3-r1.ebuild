# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/pidgin/pidgin-2.7.3.ebuild,v 1.5 2010/10/09 17:18:59 armin76 Exp $

EAPI=2

GENTOO_DEPEND_ON_PERL=no
inherit flag-o-matic eutils toolchain-funcs multilib perl-app gnome2 python autotools

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://pidgin.im/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="dbus debug doc eds gadu gnutls +gstreamer +gtk idn meanwhile"
IUSE+=" networkmanager nls perl silc tcl tk spell qq sasl +startup-notification"
IUSE+=" ncurses groupwise prediction python +xscreensaver zephyr zeroconf" # mono"

# dbus requires python to generate C code for dbus bindings (thus DEPEND only).
# finch uses libgnt that links with libpython - {R,}DEPEND. But still there is
# no way to build dbus and avoid libgnt linkage with python. If you want this
# send patch upstream.
RDEPEND="
	>=dev-libs/glib-2.12
	>=dev-libs/libxml2-2.6.18
	ncurses? ( sys-libs/ncurses[unicode]
		dbus? ( <dev-lang/python-3 )
		python? ( <dev-lang/python-3 ) )
	gtk? (
		>=x11-libs/gtk+-2.10:2
		x11-libs/libSM
		xscreensaver? ( x11-libs/libXScrnSaver )
		startup-notification? ( >=x11-libs/startup-notification-0.5 )
		spell? ( >=app-text/gtkspell-2.0.2 )
		eds? ( gnome-extra/evolution-data-server )
		prediction? ( >=dev-db/sqlite-3.3:3 ) )
	gstreamer? ( =media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-good-0.10*
		>=net-libs/farsight2-0.0.14
		media-plugins/gst-plugins-meta
		media-plugins/gst-plugins-gconf )
	zeroconf? ( net-dns/avahi )
	dbus? ( >=dev-libs/dbus-glib-0.71
		>=sys-apps/dbus-0.90 )
	perl? ( >=dev-lang/perl-5.8.2-r1[-build] )
	gadu?  ( >=net-libs/libgadu-1.9.0[-ssl] )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( >=dev-libs/nss-3.11 )
	meanwhile? ( net-libs/meanwhile )
	silc? ( >=net-im/silc-toolkit-1.0.1 )
	tcl? ( dev-lang/tcl )
	tk? ( dev-lang/tk )
	sasl? ( dev-libs/cyrus-sasl:2 )
	networkmanager? ( net-misc/networkmanager )
	idn? ( net-dns/libidn )"
	# Mono support crashes pidgin
	#mono? ( dev-lang/mono )"

DEPEND="$RDEPEND
	dev-lang/perl
	dev-perl/XML-Parser
	dev-util/pkgconfig
	gtk? ( x11-proto/scrnsaverproto )
	dbus? ( <dev-lang/python-3 )
	doc? ( app-doc/doxygen )
	nls? ( >=dev-util/intltool-0.41.1
		sys-devel/gettext )"

DOCS="AUTHORS HACKING NEWS README ChangeLog"

# Enable Default protocols
DYNAMIC_PRPLS="irc,jabber,oscar,yahoo,simple,msn,myspace"

# List of plugins
#   app-accessibility/pidgin-festival
#   net-im/librvp
#   x11-plugins/guifications
#	x11-plugins/msn-pecan
#   x11-plugins/pidgin-encryption
#   x11-plugins/pidgin-extprefs
#   x11-plugins/pidgin-hotkeys
#   x11-plugins/pidgin-latex
#   x11-plugins/pidgintex
#   x11-plugins/pidgin-libnotify
#   x11-plugins/pidgin-otr
#   x11-plugins/pidgin-rhythmbox
#   x11-plugins/purple-plugin_pack
#   x11-themes/pidgin-smileys
#	x11-plugins/pidgin-knotify
# Plugins in Sunrise:
#	x11-plugins/pidgimpd
#	x11-plugins/pidgin-birthday
#	x11-plugins/pidgin-botsentry
#	x11-plugins/pidgin-convreverse
#	x11-plugins/pidgin-extended-blist-sort
#	x11-plugins/pidgin-lastfm
#	x11-plugins/pidgin-mbpurple

pkg_setup() {
	if ! use gtk && ! use ncurses ; then
		einfo
		elog "You did not pick the ncurses or gtk use flags, only libpurple"
		elog "will be built."
		einfo
	fi
	if use dbus && ! use python; then
		elog "It's impossible to disable linkage with python in case dbus is enabled."
	fi
	if use dbus || { use ncurses && use python; }; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${PN}-2.7.2-ldflags.patch
	eautoreconf

}

src_configure() {
	# Stabilize things, for your own good
	strip-flags
	replace-flags -O? -O2

	local myconf

	if use gadu; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},gg"
			myconf="${myconf} --with-gadu-includes=."
			myconf="${myconf} --with-gadu-libs=."
	fi

	use silc && DYNAMIC_PRPLS+=",silc"
	use qq && DYNAMIC_PRPLS+=",qq"
	use meanwhile && DYNAMIC_PRPLS+=",sametime"
	use zeroconf && DYNAMIC_PRPLS+=",bonjour"
	use groupwise && DYNAMIC_PRPLS+=",novell"
	use zephyr && DYNAMIC_PRPLS+=",zephyr"

	if use gnutls; then
		einfo "Disabling NSS, using GnuTLS"
		myconf+=" --enable-nss=no --enable-gnutls=yes"
		myconf+=" --with-gnutls-includes=/usr/include/gnutls"
		myconf+=" --with-gnutls-libs=/usr/$(get_libdir)"
	else
		einfo "Disabling GnuTLS, using NSS"
		myconf+=" --enable-gnutls=no --enable-nss=yes"
	fi

	if use dbus || { use ncurses && use python; }; then
		myconf+=" --with-python=$(PYTHON)"
	else
		myconf+=" --without-python"
	fi

	econf \
		--disable-silent-rules \
		$(use_enable ncurses consoleui) \
		$(use_enable nls) \
		$(use_enable gtk gtkui) \
		$(use_enable gtk sm) \
		$(use gtk && use_enable startup-notification) \
		$(use gtk && use_enable xscreensaver screensaver) \
		$(use gtk && use_enable prediction cap) \
		$(use gtk && use_enable eds gevolution) \
		$(use gtk && use_enable spell gtkspell) \
		$(use_enable perl) \
		$(use_enable tk) \
		$(use_enable tcl) \
		$(use_enable debug) \
		$(use_enable dbus) \
		$(use_enable meanwhile) \
		$(use_enable gstreamer) \
		$(use_enable gstreamer farsight) \
		$(use_enable gstreamer vv) \
		$(use_enable sasl cyrus-sasl ) \
		$(use_enable doc doxygen) \
		$(use_enable networkmanager nm) \
		$(use_enable zeroconf avahi) \
		$(use_enable idn) \
		"--with-dynamic-prpls=${DYNAMIC_PRPLS}" \
		--disable-mono \
		--x-includes=/usr/include/X11 \
		${myconf}
		#$(use_enable mono) \
}

src_install() {
	gnome2_src_install
	if use gtk; then
		# Fix tray pathes for kde-3.5, e16 (x11-wm/enlightenment) and other
		# implementations that are not complient with new hicolor theme yet, #323355
		local pixmapdir
		for d in 16 22 32 48; do
			pixmapdir=${D}/usr/share/pixmaps/pidgin/tray/hicolor/${d}x${d}/actions
			mkdir "${pixmapdir}" || die
			pushd "${pixmapdir}" >/dev/null || die
			for f in ../status/*; do
				ln -s ${f} || die
			done
			popd >/dev/null
		done
	fi
	use perl && fixlocalpod
}
