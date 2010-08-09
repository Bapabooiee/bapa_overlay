# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.30.2.ebuild,v 1.5 2010/08/03 05:32:25 nirbheek Exp $

EAPI="2"

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha amd64 ~ia64 ~sh ~sparc x86"

IUSE="accessibility cdr cups dvdr ldap mono policykit"

S=${WORKDIR}

# FIXME: bump gstreamer to 0.10.26
# XXX: lower gdm to 2.20 since we still keep 2.28 masked
# Lower epiphany to 2.26 since 2.28 is not ready to go stable
# Lower ekiga since 3.x cannot be stabilized yet as talked with voip herd
RDEPEND="
	>=dev-libs/glib-2.24.1
	>=x11-libs/gtk+-2.20.1
	>=dev-libs/atk-1.30.0
	>=x11-libs/pango-1.28.1

	>=dev-libs/libxml2-2.7.2
	>=dev-libs/libxslt-1.1.22

	>=media-libs/audiofile-0.2.7
	>=x11-libs/libxklavier-5.0
	>=media-libs/libart_lgpl-2.3.21

	>=dev-libs/libIDL-0.8.14
	>=gnome-base/orbit-2.14.18

	>=x11-libs/libwnck-2.30.2
	>=x11-wm/metacity-2.30.1

	>=gnome-base/gnome-keyring-2.30.3
	>=app-crypt/seahorse-2.30.1

	>=gnome-base/gconf-2.28.1
	>=net-libs/libsoup-2.30.2

	>=gnome-base/libbonobo-2.24.3
	>=gnome-base/libbonoboui-2.24.3
	>=gnome-base/libgnome-2.30.0
	>=gnome-base/libgnomeui-2.24.3
	>=gnome-base/libgnomecanvas-2.30.1
	>=gnome-base/libglade-2.6.4

	>=gnome-extra/bug-buddy-2.30.0
	>=gnome-base/libgnomekbd-2.30.1
	>=gnome-base/gnome-settings-daemon-2.30.2
	>=gnome-base/gnome-control-center-2.30.1

	>=gnome-base/nautilus-2.30.1

	>=media-libs/gstreamer-0.10.29
	>=media-libs/gst-plugins-base-0.10.29
	>=media-libs/gst-plugins-good-0.10.22
	>=gnome-extra/gnome-media-2.30.0
	>=media-sound/sound-juicer-2.28.2
	>=dev-libs/totem-pl-parser-2.30.1
	>=media-video/totem-2.30.2
	>=media-video/cheese-2.30.1

	>=media-gfx/eog-2.30.2

	>=www-client/epiphany-2.30.2
	>=app-arch/file-roller-2.30.2
	>=gnome-extra/gcalctool-5.28.2

	>=gnome-extra/gconf-editor-2.30.0
	>=gnome-base/gdm-2.20.11
	>=x11-libs/gtksourceview-2.10.4:2.0
	>=app-editors/gedit-2.30.3

	>=app-text/evince-2.30.2

	>=gnome-base/gnome-desktop-2.30.2
	>=gnome-base/gnome-session-2.30.2
	>=dev-libs/libgweather-2.30.2
	>=gnome-base/gnome-applets-2.30.0
	>=gnome-base/gnome-panel-2.30.0
	>=gnome-base/gnome-menus-2.30.2-r1
	>=x11-themes/gnome-icon-theme-2.30.3
	>=x11-themes/gnome-themes-2.30.2
	>=gnome-extra/deskbar-applet-2.30.1

	>=x11-themes/gtk-engines-2.20.1
	>=x11-themes/gnome-backgrounds-2.30.0

	>=x11-libs/vte-0.24.2
	>=x11-terms/gnome-terminal-2.30.2

	>=gnome-extra/gucharmap-2.30.2
	>=gnome-base/libgnomeprint-2.18.7
	>=gnome-base/libgnomeprintui-2.18.5

	>=gnome-extra/gnome-utils-2.30.0

	>=gnome-base/librsvg-2.26.3

	>=gnome-extra/gnome-system-monitor-2.28.1
	>=gnome-base/libgtop-2.28.1

	>=x11-libs/startup-notification-0.9

	>=gnome-extra/gnome-user-docs-2.30.1
	>=gnome-extra/yelp-2.30.1
	>=gnome-extra/zenity-2.30.0

	>=net-analyzer/gnome-netstatus-2.28.1
	>=net-analyzer/gnome-nettool-2.30.0

	cdr? ( >=app-cdr/brasero-2.30.2 )
	dvdr? ( >=app-cdr/brasero-2.30.2 )

	>=gnome-extra/gtkhtml-3.30.2
	>=mail-client/evolution-2.30.2
	>=gnome-extra/evolution-data-server-2.30.2
	>=gnome-extra/evolution-webcal-2.28.1

	>=net-misc/vino-2.28.2

	>=app-admin/pessulus-2.30.2
	ldap? (
		>=app-admin/sabayon-2.30.0
		>=net-voip/ekiga-2.0.12 )

	>=gnome-extra/gnome-screensaver-2.30.0
	>=x11-misc/alacarte-0.12.4
	>=gnome-extra/gnome-power-manager-2.30.1

	>=net-misc/vinagre-2.30.2
	>=gnome-extra/swfdec-gnome-2.30.0

	accessibility? (
		>=gnome-extra/libgail-gnome-1.20.2
		>=gnome-extra/at-spi-1.30.1
		>=app-accessibility/dasher-4.11
		>=app-accessibility/gnome-mag-0.16.1
		>=app-accessibility/gnome-speech-0.4.25
		>=app-accessibility/gok-2.30.0
		>=app-accessibility/orca-2.30.2
		>=gnome-extra/mousetweaks-2.30.2 )
	cups? ( >=net-print/gnome-cups-manager-0.31-r2 )

	mono? (
		>=dev-dotnet/gtk-sharp-2.12.10
		>=app-misc/tomboy-1.2.1 )
	policykit? ( gnome-extra/polkit-gnome )"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.6.2[gdu]"
# Broken from assumptions of gnome-vfs headers being included in nautilus headers,
# which isn't the case with nautilus-2.22, bug #216019
#	>=app-admin/gnome-system-tools-2.28.2
#	>=app-admin/system-tools-backends-2.8

# Development tools
#   scrollkeeper
#   pkgconfig
#   intltool
#   gtk-doc
#   gnome-doc-utils

pkg_postinst() {
# FIXME: Rephrase to teach about using different WMs instead, as metacity is the default anyway
# FIXME: but first check WINDOW_MANAGER is still honored in 2.24. gnome-session-2.24 might have lost
# FIXME: support for it, but we don't ship with gnome-session-2.24 yet
#	elog "Note that to change windowmanager to metacity do: "
#	elog " export WINDOW_MANAGER=\"/usr/bin/metacity\""
#	elog "of course this works for all other window managers as well"

	elog "The main file alteration monitoring functionality is"
	elog "provided by >=glib-2.16. Note that on a modern Linux system"
	elog "you do not need the USE=fam flag on it if you have inotify"
	elog "support in your linux kernel ( >=2.6.13 ) enabled."
	elog "USE=fam on glib is however useful for other situations,"
	elog "such as Gentoo/FreeBSD systems. A global USE=fam can also"
	elog "be useful for other packages that do not use the new file"
	elog "monitoring API yet that the new glib provides."
	elog
	elog
	elog "Add yourself to the plugdev group if you want"
	elog "automounting to work."
	elog
}
