EAPI=2

CMAKE_IN_SOURCE_BUILD="Non Facet Nobis"
EGIT_REPO_URI="https://github.com/miniBill/flatWorld.git"

inherit eutils games cmake-utils git

DESCRIPTION="A small game"
HOMEPAGE="https://github.com/miniBill/flatWorld"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="media-libs/libcaca[ncurses]"
DEPEND="${RDEPEND} dev-util/cmake"

src_install() { 
	newgamesbin flatWorld ${PN} || die "newbin failed"
	dodoc README || die "dodoc failed"
}
