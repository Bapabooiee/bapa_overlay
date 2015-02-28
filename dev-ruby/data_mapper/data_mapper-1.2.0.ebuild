EAPI=4

USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

# Yeah, like I'm making ebuilds for all these...
DM_DEPS=(
	$PN
	dm-core
	dm-aggregates
	dm-constraints
	dm-migrations
	dm-transactions
	dm-serializer
	dm-timestamps
	dm-validations
	dm-types
	dm-do-adapter
)

DM_ADAPTERS=( )

inherit ruby-ng ruby-fakegem

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite"

for gemname in ${DM_DEPS[@]}; do
	SRC_URI="${SRC_URI} mirror://rubygems/${gemname}-${PV}.gem"
done

SRC_URI="${SRC_URI} mysql? ( mirror://rubygems/dm-mysql-adapter-${PV}.gem )"
if use mysql; then
	DM_DEPS+=( dm-mysql-adapter )
fi

SRC_URI="${SRC_URI} sqlite? ( mirror://rubygems/dm-sqlite-adapter-${PV}.gem )"
if use sqlite; then
	DM_DEPS+=( dm-sqlite-adapter )
fi

SRC_URI="${SRC_URI} postgres? ( mirror://rubygems/dm-postgres-adapter-${PV}.gem )"
if use postgres; then
	DM_DEPS+=( dm-postgres-adapter )
fi

# Note that dev-ruby/spruz has been supereseded by
# dev-ruby/tins. Might wanna fix that in the gemspec.
# 
# json & json_pure seem to be the same thing also,
# but for some reason it wants them both.
#
# TODO: Fix data_mapper's gemspec(s) so that it isn't
# so finnicky about Gem versions.
ruby_add_rdepend "=dev-ruby/addressable-2.2.6
	=dev-ruby/multi_json-1.0.3
	=dev-ruby/json-1.5.4
	=dev-ruby/json_pure-1.5.4
	=dev-ruby/fastercsv-1.5.5
	dev-ruby/spruz
	=dev-ruby/stringex-1.3.2
	=dev-ruby/bcrypt-ruby-3.0.1
	=dev-ruby/uuidtools-2.1.2
	=dev-ruby/data_objects-0.10.6
	sqlite? ( dev-ruby/do_sqlite3 )
	mysql? ( dev-ruby/do_mysql )
	postgres? ( dev-ruby/do_postgres )
"

_unpack_gem() {
		mkdir $1
		pushd $1 > /dev/null
		ebegin "Extracting $1"
		tar -mxf ${DISTDIR}/$1.gem || die
		gunzip metadata.gz || die
		tar -mxf data.tar.gz || die
		popd > /dev/null
}

_install_gem() {
		local gemname=$i-$PV
		local metadata="${WORKDIR}"/${_ruby_implementation}/$gemname/metadata
		local gemspec="${T}"/$gemname-$PV-${_ruby_implementation}.gemspec

		ebegin "Installing ${gemname}"
		pushd $gemname > /dev/null
		ruby_fakegem_metadata_gemspec $metadata "${gemspec}"

		insinto	$(ruby_fakegem_gemsdir)/specifications
		newins $gemspec $gemname.gemspec

		insinto $(ruby_fakegem_gemsdir)/gems/$gemname
		doins -r lib

		popd > /dev/null
}

all_ruby_unpack() {
	local gemname=

	for i in ${DM_DEPS[@]}; do
		gemname=$i-$PV
		_unpack_gem $gemname
	done
}

each_ruby_install() {
	pushd .. > /dev/null
	for i in ${DM_DEPS[@]}; do
		_install_gem $i
	done
	popd > /dev/null
}
