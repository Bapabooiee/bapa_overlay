# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="https://github.com/facebook/${PN}.git"

inherit eutils git distutils

DESCRIPTION="Facebook's PHP shell, ironically written mostly in Python"
HOMEPAGE="http://www.phpsh.org/"

LICENSE="phpsh LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+pcntl"

DEPEND=""
RDEPEND="dev-lang/php[pcntl?]"

src_prepare() {
	git_src_prepare
	distutils_src_prepare

	epatch "${FILESDIR}"/${PN}-setup.patch
}
