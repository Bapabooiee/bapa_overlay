# $Header:

EAPI="3"

inherit python

DESCRIPTION="Erlang package manager"
HOMEPAGE="http://code.google.com/p/faxien/"
SRC_URI="http://faxien.googlecode.com/files/${PN}-universal-${PV}.py -> ${P}.py"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

src_install() {
	dobin "${DISTDIR}/${P}.py"
	cd ${D}/usr/bin
	mv "${P}.py" "${PN}"
}
