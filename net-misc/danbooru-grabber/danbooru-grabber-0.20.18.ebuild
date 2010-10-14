# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MY_PN=danbooru-v7sh-grabber
MY_P=${MY_PN}-v${PV}

DESCRIPTION="POSIX shell script to download images from Danbooru and Gelbooru"
HOMEPAGE="http://code.google.com/p/danbooru-v7sh-grabber"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	newbin grab.sh ${PN} || die
}

pkg_postinst() {
	elog "Please note that ${PN} also works with Gelbooru."
	elog "Just specify \`--engine gelbooru' when running the script."
	elog
	elog "If you need a crash-course on how to use the script, please"
	elog "visit ${HOMEPAGE}/wiki/Main"
}
