EAPI=4

USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-ng ruby-fakegem

DESCRIPTION="LevelDB gem for Ruby"
HOMEPAGE="http://rubygems.org/gems/leveldb-ruby"

LICENSE="leveldb-ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/leveldb"
RDEPEND="${DEPEND}"

each_ruby_configure() {
	${RUBY} -C ext/leveldb extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -C ext/leveldb CFLAGS="${CFLAGS} -fPIC" archflags="${LDFLAGS}"
}

each_ruby_install() {
	each_fakegem_install

	# currently no elegant way to do this (bug #352765)
	ruby_fakegem_newins ext/leveldb/leveldb.so lib/leveldb/leveldb.so
}
