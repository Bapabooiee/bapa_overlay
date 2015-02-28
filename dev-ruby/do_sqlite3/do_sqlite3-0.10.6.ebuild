EAPI=2

USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_TASK_DOC="rdoc"

RUBY_FAKEGEM_DOCDIR="rdoc"
#RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-dmext

DESCRIPTION="Implements the DataObjects API for SQLite3"
HOMEPAGE="http://rubygems.org/gems/do_sqlite3"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
