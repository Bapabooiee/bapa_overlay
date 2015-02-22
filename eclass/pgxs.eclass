
EGIT_REPO_URI="https://github.com/dpage/${PN}.git"

inherit git-2

src_compile() {
	emake USE_PGXS=1
}

src_install() {
	emake USE_PGXS=1 DESTDIR="${D}" install
	[ -e README ] && dodoc README
}
