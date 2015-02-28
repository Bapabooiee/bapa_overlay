# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/spruz/spruz-0.2.13.ebuild,v 1.1 2012/07/08 12:53:45 flameeyes Exp $

EAPI=4

USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="All the stuff that isn't good enough for a real library."
HOMEPAGE="http://github.com/flori/spruz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"

all_ruby_prepare() {
	# sdoc is not available for Gentoo yet, use rdoc instead
	sed -i -e 's/sdoc/rdoc/' Rakefile || die
	# Fix glob expansion so that documentation can be built
	sed -i -e "s/} \* ' '}/.join(' ')}/" Rakefile || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib tests/*_test.rb
}
