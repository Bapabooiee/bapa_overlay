EAPI=4

MY_PV=${PV//./_}

inherit eutils

DESCRIPTION="HTML documentation for Ruby's core and stdlib"
HOMEPAGE="http://ruby-doc.org"

# Currently, you'll get 403'd if you try to use wget to fetch these.
SRC_URI="http://ruby-doc.org/downloads/ruby_${MY_PV}_core_rdocs.tgz
		 http://ruby-doc.org/downloads/ruby_${MY_PV}_stdlib_rdocs.tgz"
LICENSE="Ruby-BSD BSD-2"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

src_install() {
	docinto html/core
	dodoc -r ruby_${MY_PV}_core/*

	docinto html/stdlib
	dodoc -r ruby_${MY_PV}_stdlib/*
}
