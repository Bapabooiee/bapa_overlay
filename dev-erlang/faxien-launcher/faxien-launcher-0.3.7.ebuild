EAPI=2

MY_P=${PN}-universal-${PV}

DESCRIPTION="Erlang package manager"
HOMEPAGE="http://code.google.com/p/faxien/"
SRC_URI="http://faxien.googlecode.com/files/${MY_P}.py -> ${P}.py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/erlang >=dev-lang/python-2.4"

src_install() {
	newbin "${DISTDIR}/${P}.py" ${PN}
}
