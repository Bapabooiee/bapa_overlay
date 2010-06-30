# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/radiotray/radiotray-0.6.ebuild,v 1.1 2010/06/12 10:21:41 hwoarang Exp $

EAPI=3

PYTHON_DEPEND="2"
inherit distutils eutils

DESCRIPTION="Online radio streaming player"
HOMEPAGE="http://radiotray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/gst-python
	dev-python/pygtk
	dev-python/lxml
	dev-python/pyxdg
	dev-python/pygobject
	dev-python/notify-python
	media-plugins/gst-plugins-libmms
	media-plugins/gst-plugins-ffmpeg
	media-plugins/gst-plugins-mad
	media-plugins/gst-plugins-ogg
	media-plugins/gst-plugins-vorbis
	media-plugins/gst-plugins-soup"

DEPEND="${RDEPEND}"

DOCS="AUTHORS CONTRIBUTORS NEWS README"

src_prepare() {
	python_convert_shebangs -r 2 .
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-dialogfix.patch"
}
