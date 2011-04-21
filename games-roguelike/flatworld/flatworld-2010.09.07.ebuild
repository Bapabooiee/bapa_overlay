EAPI=3

CMAKE_IN_SOURCE_BUILD="Non Facet Nobis"

EGIT_REPO_URI="https://github.com/miniBill/flatWorld.git"
EGIT_COMMIT="219161ea4a6ea6ec5b576fc8e9f6f1030ac59a70"

inherit eutils games cmake-utils git

DESCRIPTION="A small game"
HOMEPAGE="https://github.com/miniBill/flatWorld"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

src_install() {
	newgamesbin flatWorld ${PN} || die "newbin failed"
	dodoc README || die "dodoc failed"
}
