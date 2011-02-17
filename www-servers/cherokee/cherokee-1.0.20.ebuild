# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/cherokee/cherokee-1.0.12.ebuild,v 1.1 2010/12/02 13:55:12 bass Exp $

EAPI=2
PYTHON_DEPEND="admin? 2"

inherit python eutils pam versionator libtool

DESCRIPTION="An extremely fast and tiny web server."
SRC_URI="http://www.cherokee-project.com/download/$(get_version_component_range 1-2)/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.cherokee-project.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ipv6 nls ssl static pam coverpage threads kernel_linux admin debug geoip
ldap mysql ffmpeg fastcgi rrdtool"

RDEPEND="
	>=sys-libs/zlib-1.1.4-r1
	rrdtool? ( net-analyzer/rrdtool )
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl )
	pam? ( virtual/pam )
	geoip? ( dev-libs/geoip )
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	fastcgi? ( www-servers/spawn-fcgi )
	ffmpeg? ( media-video/ffmpeg )"
DEPEND="${RDEPEND}"

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_configure() {
	local myconf

	if use static ; then
		myconf="${myconf} --enable-static --enable-static-module=all"
	else
		myconf="${myconf} --disable-static"
	fi

	if use debug ; then
		myconf="${myconf} --enable-trace"
	fi

	local os="Unknown"
	case "${CHOST}" in
		*-freebsd*)
			os="FreeBSD" ;;
		*-netbsd*)
			os="NetBSD" ;;
		*-openbsd*)
			os="OpenBSD" ;;
		*)
			os="Linux" ;;
	esac

	# No options to enable or disable ssl since Cherokee 0.11
	econf \
		${myconf} \
		$(use_enable pam) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable threads pthread) \
		$(use_enable kernel_linux epoll) \
		$(use_with geoip) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_with ffmpeg) \
		--disable-dependency-tracking \
		--enable-os-string="Gentoo ${os}" \
		--with-wwwroot=/var/www/localhost/htdocs \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		|| die "configure failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install () {
	emake -j1 DESTDIR="${D}" docdir="/usr/share/doc/${PF}/html" install || die "make install failed"

	dodoc AUTHORS ChangeLog

	use pam && pamd_mimic system-auth cherokee auth account session
	newinitd "${FILESDIR}/${PN}-initd-0.99.23" ${PN} || die "newinitd failed"

	dodir /usr/share/doc/${PF}/contrib
	insinto /usr/share/${PF}/contrib
	doins contrib/07to08.py
	doins contrib/08to09.py
	doins contrib/09to010.py
	doins contrib/011to098.py
	doins contrib/098to099.py
	doins contrib/0999to09910.py
	doins contrib/make-cert.sh

	keepdir /etc/cherokee/mods-enabled /etc/cherokee/sites-enabled /var/www/localhost/htdocs

	use coverpage || rm -rf "${D}"/var/www/localhost/htdocs/{index.html,images}
	if use admin ; then
		exeinto /usr/share/cherokee/admin
		doexe admin/server.py
	else
		rm -rf "${D}"/usr/sbin/admin "${D}"/usr/share/cherokee/admin
	fi

	# Puts logs in /var/log/cherokee/
	dosed "s:/var/log/cherokee\.:/var/log/cherokee/cherokee\.:g" /etc/cherokee/cherokee.conf

}

pkg_setup() {
	python_set_active_version 2
}

pkg_postinst() {
	enewgroup cherokee
	enewuser cherokee -1 -1 /var/www/localhost cherokee
	install -o cherokee -g cherokee -m0775 -d "${ROOT}"var/log/cherokee

	# check if user/group was defined if not add it
	gr="/bin/grep -q"
	ec="/bin/echo"
	$gr server\!user /etc/cherokee/cherokee.conf ; rtu=$?
	$gr server\!group /etc/cherokee/cherokee.conf ; rtg=$?

	[[ "x$rtu" == "x1" ]] && $ec server\!user = cherokee >> /etc/cherokee/cherokee.conf
	[[ "x$rtg" == "x1" ]] && $ec server\!group = cherokee >> /etc/cherokee/cherokee.conf

	if use admin ; then
		echo  ""
		elog "Just run 'cherokee-admin' and go to: http://localhost:9090"
		echo  ""
	else
		echo  ""
		elog "Try USE=admin if you want an easy way to configure cherokee."
		echo  ""
	fi

	echo ""
	elog "Config format can change in different versions. Check converter script in:"
	elog "	  /usr/share/cherokee-0.99.15/contrib/"
	elog "for example:"
	elog "	  PYTHONPATH="/usr/share/cherokee/admin/" python \\"
	elog "	  /usr/share/cherokee-0.99.15/contrib/0999to09910.py \\"
	elog "	  /etc/cherokee/cherokee.conf /etc/cherokee/cherokee.conf-0.99.15"

}
