EAPI="2"

DESCRIPTION="Pidgin Xfire plugin"
HOMEPAGE="http://gfireproject.org/"
SRC_URI="mirror://sourceforge/gfire/${P}.tar.bz2"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="debug dbus libnotify nls"

RDEPEND=">=net-im/pidgin-2.5.0
				dbus? ( dev-libs/dbus-glib )
				gtk? ( >=x11-libs/gtk+-2.14.0 )
				libnotify? ( >=x11-libs/libnotify-0.3.2 )"
				
DEPEND="dev-util/pkgconfig
			${DEPEND}"

src_configure() {
	econf $(use_enable debug) \
		  $(use_enable libnotify) \
		  $(use_enable dbus dbus-status) \
		  $(use_enable nls) \
		  $(use_enable gtk) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYING README NEWS VERSION ChangeLog || die "dodoc failed"
}
