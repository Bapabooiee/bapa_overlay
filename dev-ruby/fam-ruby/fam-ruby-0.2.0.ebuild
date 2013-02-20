EAPI=4

USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README event_codes AUTHORS ChangeLog"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-ng ruby-fakegem

SRC_URI="http://pablotron.org/files/${P}.tar.gz"
DESCRIPTION="File-Alteration Monitor bindings for Ruby"
HOMEPAGE="http://raa.ruby-lang.org/project/fam-ruby/"

LICENSE="fam-ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-libs/libgamin"
RDEPEND="${DEPEND}"

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" archflags="${LDFLAGS}"
}

each_ruby_install() {
	each_fakegem_install

	# currently no elegant way to do this (bug #352765)
	ruby_fakegem_newins fam.so lib/fam.so
}

all_ruby_install() {
	if use doc; then
		dohtml -r doc	
	fi

	if use examples; then
		dodoc -r examples
	fi
}
