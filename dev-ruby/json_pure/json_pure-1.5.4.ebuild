EAPI=2

USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_TASK_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="An implementation of JSON for Ruby"
HOMEPAGE="http://flori.github.com/json/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

each_ruby_prepare() {
	# TODO: Fix data_mapper so that it doesn't
	# depend on both json/json_pure.
	rm -rf bin # clashes with dev-ruby/json
}
