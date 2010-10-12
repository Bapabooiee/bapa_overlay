# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="POSIX shell script to download images from Danbooru and Gelbooru"
HOMEPAGE="http://code.google.com/p/danbooru-v7sh-grabber/"

MY_PN="danbooru-v7sh-grabber"
MY_DIST="${MY_PN}-v${PV}"

SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_DIST}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

# Note: The script can choose between wget, curl, fetch 
# and axel for its download engine; might want to
# consider adding USE flags for them later.
IUSE=""

S="${WORKDIR}/${MY_DIST}"

src_install() {
	newbin "grab.sh" "danbooru-grabber" || die "newbin failed"
	dosym /usr/bin/danbooru-grabber /usr/bin/dgrab || die "dosym failed"
}

pkg_postinst() {
	elog "Please note that ${PN} also works with Gelbooru."
	elog "Just specify \`--engine gelbooru' when running the script."
	elog 
	elog "If you need a crash-course on how to use the script, please"
	elog "visit https://code.google.com/p/danbooru-v7sh-grabber/wiki/Main"
}
