# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/youtube-dl/youtube-dl-2010.10.03.ebuild,v 1.1 2010/10/04 02:23:14 ricmm Exp $

EAPI=3
PYTHON_DEPEND=2:2.4

inherit python

DESCRIPTION="A small command-line program to download videos from YouTube."
HOMEPAGE="http://bitbucket.org/rg3/youtube-dl/"
SRC_URI="http://bitbucket.org/rg3/${PN}/get/${PV}.bz2 -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	newbin "${PN}/${PN}" ${PN}
	python_convert_shebangs -r 2 "${D}"
}
