inherit ruby-ng ruby-fakegem

each_ruby_configure() {
	${RUBY} -C ext/${PN} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -C ext/${PN} CFLAGS="${CFLAGS} -fPIC" archflags="${LDFLAGS}" || die "emake failed"
}

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_newins ext/${PN}/${PN}.so lib/${PN}/${PN}.so 
}
