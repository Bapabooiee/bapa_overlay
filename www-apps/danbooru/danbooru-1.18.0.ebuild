# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

USE_RUBY="ruby18"

if [[ ${PV} == "9999" ]]; then
	ESVN_REPO_URI="svn://donmai.us/danbooru/trunk"
else
	ESVN_REPO_URI="svn://donmai.us/danbooru/tags/${P}"
fi

inherit eutils subversion webapp

DESCRIPTION="A taggable image board with many advanced features"
HOMEPAGE="http://trac.donmai.us/"
SRC_URI=""

LICENSE="as-is"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

my_resizer=lib/danbooru_image_resizer

src_unpack() {
	subversion_src_unpack
	#ruby-ng_src_unpack
}

src_prepare() {
	#rm -rf tmp components
	rm -f ${my_resizer}/*.so
}

src_configure() {
	ruby -C ${my_resizer} extconf.rb || die "extconf.rb failed"
}

src_compile() {
	emake -C ${my_resizer} || die "emake failed"
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL{,.debian,.freebsd} || die "dodoc failed"

	find ${my_resizer} -type f ! -name '*.so' -delete || die "find -delete failed"

	insinto "${MY_HTDOCSDIR}"

	doins -r \
		app \
		config \
		db \
		lib \
		public \
		script \
		vendor \
		Rakefile || die "doins failed"

	
	webapp_serverowned -R "${MY_HTDOCSDIR}"/public/data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/config
	webapp_configfile "${MY_HTDOCSDIR}"/config

	webapp_sqlscript postgres "${D}/${MY_HTDOCSDIR}"/db/postgres.sql

	webapp_src_install
}



