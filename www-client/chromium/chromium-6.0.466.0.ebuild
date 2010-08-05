# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/chromium/chromium-6.0.466.0.ebuild,v 1.1 2010/07/16 00:27:44 phajdan.jr Exp $

EAPI="2"

inherit eutils flag-o-matic multilib pax-utils toolchain-funcs

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="http://build.chromium.org/buildbot/official/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cups gnome sse2"

RDEPEND="app-arch/bzip2
	>=dev-libs/libevent-1.4.13
	>=dev-libs/nss-3.12.3
	>=gnome-base/gconf-2.24.0
	gnome? ( >=gnome-base/gnome-keyring-2.28.2 )
	>=media-libs/alsa-lib-1.0.19
	media-libs/jpeg:0
	media-libs/libpng
	media-video/ffmpeg[threads]
	cups? ( >=net-print/cups-1.3.5 )
	sys-libs/zlib
	>=x11-libs/gtk+-2.14.7
	x11-libs/libXScrnSaver"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconfig-0.23
	>=gnome-base/gnome-keyring-2.28.2
	sys-devel/flex"
RDEPEND+="
	|| (
		x11-themes/gnome-icon-theme
		x11-themes/oxygen-molecule
		x11-themes/tango-icon-theme
		x11-themes/xfce4-icon-theme
	)
	x11-apps/xmessage
	x11-misc/xdg-utils
	virtual/ttf-fonts"

get_chromium_home() {
	echo "/usr/$(get_libdir)/chromium-browser"
}

remove_bundled_lib() {
	einfo "Removing bundled library $1 ..."
	local out
	out="$(find $1 -mindepth 1 \! -iname '*.gyp' -print -delete)" \
		|| die "failed to remove bundled library $1"
	if [[ -z $out ]]; then
		die "no files matched when removing bundled library $1"
	fi
}

src_prepare() {
	# Disable VP8 until we have a recent enough system-provided ffmpeg.
	epatch "${FILESDIR}"/${PN}-disable-vp8-r1.patch

	remove_bundled_lib "third_party/bzip2"
	remove_bundled_lib "third_party/libevent"
	remove_bundled_lib "third_party/libjpeg"
	remove_bundled_lib "third_party/libpng"
	# TODO: also remove third_party/libxml and third_party/libxslt when
	# http://crbug.com/29333 is fixed.
	# TODO: also remove third_party/zlib. For now the compilation fails if we
	# remove it (minizip-related).
}

src_configure() {
	local myconf=""

	# Make it possible to build chromium on non-sse2 systems.
	if use sse2; then
		myconf="${myconf} -Ddisable_sse2=0"
	else
		myconf="${myconf} -Ddisable_sse2=1"
	fi

	# Use system-provided libraries.
	# TODO: use_system_libxml (http://crbug.com/29333).
	# TODO: use_system_sqlite (http://crbug.com/22208).
	# TODO: use_system_icu, use_system_hunspell (upstream changes needed).
	# TODO: use_system_ssl when we have a recent enough system NSS.
	myconf="${myconf}
		-Duse_system_bzip2=1
		-Duse_system_ffmpeg=1
		-Duse_system_libevent=1
		-Duse_system_libjpeg=1
		-Duse_system_libpng=1
		-Duse_system_zlib=1"

	# The system-provided ffmpeg supports more codecs. Enable them in chromium.
	myconf="${myconf} -Dproprietary_codecs=1"

	# The dependency on cups is optional, see bug #324105.
	if use cups; then
		myconf="${myconf} -Duse_cups=1"
	else
		myconf="${myconf} -Duse_cups=0"
	fi

	# Enable sandbox.
	myconf="${myconf}
		-Dlinux_sandbox_path=$(get_chromium_home)/chrome_sandbox
		-Dlinux_sandbox_chrome_path=$(get_chromium_home)/chrome"

	# Disable the V8 snapshot. It breaks the build on hardened (bug #301880),
	# and the performance gain isn't worth it.
	myconf="${myconf} -Dv8_use_snapshot=0"

	# Disable tcmalloc memory allocator. It causes problems,
	# for example bug #320419.
	myconf="${myconf} -Dlinux_use_tcmalloc=0"

	# Disable gpu rendering, it is incompatible with nvidia-drivers,
	# bug #319331.
	myconf="${myconf} -Denable_gpu=0"

	# Use target arch detection logic from bug #296917.
	local myarch="$ABI"
	[[ $myarch = "" ]] && myarch="$ARCH"

	if [[ $myarch = amd64 ]] ; then
		myconf="${myconf} -Dtarget_arch=x64"
	elif [[ $myarch = x86 ]] ; then
		myconf="${myconf} -Dtarget_arch=ia32"
	elif [[ $myarch = arm ]] ; then
		# TODO: check this again after
		# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=39509 is fixed.
		append-flags -fno-tree-sink

		myconf="${myconf} -Dtarget_arch=arm -Ddisable_nacl=1 -Dlinux_use_tcmalloc=0"
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "44" ]]; then
		myconf="${myconf} -Dno_strict_aliasing=1 -Dgcc_version=44"
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf="${myconf} -Dwerror="

	build/gyp_chromium -f make build/all.gyp ${myconf} --depth=. || die "gyp failed"
}

src_compile() {
	emake -r V=1 chrome chrome_sandbox BUILDTYPE=Release \
		rootdir="${S}" \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB) \
		|| die "compilation failed"
}

src_install() {
	dodir "$(get_chromium_home)"

	exeinto "$(get_chromium_home)"
	pax-mark m out/Release/chrome
	doexe out/Release/chrome
	doexe out/Release/chrome_sandbox
	fperms 4755 "$(get_chromium_home)/chrome_sandbox"
	doexe out/Release/xdg-settings
	doexe "${FILESDIR}"/chromium-launcher.sh

	insinto "$(get_chromium_home)"
	doins out/Release/chrome.pak || die "installing chrome.pak failed"
	doins out/Release/resources.pak || die "installing resources.pak failed"

	doins -r out/Release/locales
	doins -r out/Release/resources

	# chrome.1 is for chromium --help
	newman out/Release/chrome.1 chrome.1
	newman out/Release/chrome.1 chromium.1

	# Chromium looks for these in its folder
	# See media_posix.cc and base_paths_linux.cc
	dosym /usr/$(get_libdir)/libavcodec.so.52 "$(get_chromium_home)"
	dosym /usr/$(get_libdir)/libavformat.so.52 "$(get_chromium_home)"
	dosym /usr/$(get_libdir)/libavutil.so.50 "$(get_chromium_home)"

	# Use system plugins by default.
	dosym /usr/$(get_libdir)/nsbrowser/plugins "$(get_chromium_home)/plugins"

	# Install icon and desktop entry.
	newicon out/Release/product_logo_48.png ${PN}-browser.png
	dosym "$(get_chromium_home)/chromium-launcher.sh" /usr/bin/chromium
	make_desktop_entry chromium "Chromium" ${PN}-browser "Network;WebBrowser" \
		"MimeType=text/html;text/xml;application/xhtml+xml;"
	sed -e "/^Exec/s/$/ %U/" -i "${D}"/usr/share/applications/*.desktop \
		|| die "desktop file sed failed"

	# Install GNOME default application entry (bug #303100).
	dodir /usr/share/gnome-control-center/default-apps
	insinto /usr/share/gnome-control-center/default-apps
	doins "${FILESDIR}"/chromium.xml
}
