# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS='3.*'

inherit distutils

MY_PN=JPype
MY_P=${MY_PN}-${PV}

DESCRIPTION="Allow python programs full access to java class libraries"
HOMEPAGE="http://jpype.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="examples"

RDEPEND=""
DEPEND="app-arch/unzip"

S="${WORKDIR}"/${MY_P}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r {examples,test} || die
	fi
}
