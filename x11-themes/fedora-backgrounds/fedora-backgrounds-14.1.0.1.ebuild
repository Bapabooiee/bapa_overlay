# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# x11-themes/fedora-backgrounds -- stolen from Flameeyes' overlay :)

EAPI=3

inherit versionator rpm

# Set the SLOT first thing, so that we have one ebuild per Fedora
# release.
if [[ $(get_version_component_range 2) -ge 90 ]]; then
	SLOT=$(($(get_version_component_range 1) + 1))
else
	SLOT=$(get_version_component_range 1)
fi

SRC_PATH=development/14/source/SRPMS
FEDORA=14

CODENAME="laughlin"
MY_PN="${CODENAME}-backgrounds"
MY_P="${MY_PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F${SLOT}_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${MY_PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CCPL-Attribution-ShareAlike-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	rpm_src_unpack

	# as of 2010-06-21 rpm.eclass does not unpack the further lzma
	# file automatically.
	unpack ./${MY_P}.tar.lzma
}

src_compile() { :; }
src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
}
