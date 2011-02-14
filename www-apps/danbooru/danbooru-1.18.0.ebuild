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

inherit eutils multilib subversion webapp

DESCRIPTION="A taggable image board with many advanced features"
HOMEPAGE="http://danbooru.donmai.us/ http://trac.donmai.us/"
SRC_URI=""

LICENSE="as-is"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

myresizer=danbooru_image_resizer
myresizerlib=lib/${myresizer}/${myresizer}.so

install_resizer() {
	local mylibdir=${D}/usr/$(get_libdir)/${PN}/${PV}

	mkdir -p ${mylibdir} || die "mkdir failed"
	cp ${myresizerlib} "${mylibdir}" || die "cp image_resizer failed"
	rm -rf lib/${myresizer}/* || die "rm -rf failed"
	dosym "${mylibdir}"/${myresizer}.so "${MY_HTDOCSDIR}"/${myresizerlib} || die "dosym failed"
}

install_examples() {
	local exampledir=/usr/share/doc/${PF}/config

	mkdir -p "${D}"/${exampledir}
	insinto ${exampledir}

	for i in config/{database.yml,local_config.rb}; do
		doins $i.example || die "doins doc failed"
		mv $i.example $i || die "mv doc failed"
	done
}

src_prepare() {
	#rm -rf tmp components
	rm -f ${myresizerlib}
}

src_configure() {
	ruby -C lib/${myresizer} extconf.rb || die "extconf.rb failed"
}

src_compile() {
	emake -C lib/${myresizer} || die "emake failed"
}

src_install() {
	webapp_src_preinst

	dodoc INSTALL{,.debian,.freebsd} || die "dodoc failed"
	install_examples

	install_resizer

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
	webapp_configfile "${MY_HTDOCSDIR}"/config
	webapp_sqlscript postgres "${D}/${MY_HTDOCSDIR}"/db/postgres.sql

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
