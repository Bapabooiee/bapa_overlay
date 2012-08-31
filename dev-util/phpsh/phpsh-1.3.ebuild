# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/facebook/${PN}.git"
if [[ ${PV} != "9999" ]]; then
	EGIT_COMMIT=${PV}
fi

PYTHON_DEPEND="*"
PYTHON_USE_WITH="sqlite"

inherit eutils git-2 distutils

DESCRIPTION="Facebook's PHP shell, ironically written mostly in Python"
HOMEPAGE="http://www.phpsh.org/"

LICENSE="phpsh LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pcntl"

DEPEND=""
RDEPEND="dev-lang/php[pcntl?]"

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}"/${PN}-setup.patch
}
