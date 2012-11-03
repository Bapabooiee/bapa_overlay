EAPI=4

inherit distutils

DESCRIPTION="Neo4J driver for Python"
HOMEPAGE="http://neo4j.org/"
SRC_URI="http://pypi.python.org/packages/source/n/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=virtual/jre-1.5
	dev-python/jpype"
