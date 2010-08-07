# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="a tool for monitoring Linksys BEFSR41 and BEFSR11 firewalls"

HOMEPAGE="http://woogie.net/linksysmon/"

SRC_URI="http://woogie.net/linksysmon/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="net-analyzer/net-snmp
	dev-lang/perl
	mail-client/mailx"

S="${WORKDIR}/${P}"

src_compile() {
   cd ${S}
   perl Makefile.PL PREFIX=${D}/usr || die
   emake || die
}

src_install() {
   mkdir -p ${D}/etc/init.d ${D}/etc/cron.daily ${D}/etc/logrotate.d ${D}/usr/sbin

   cd ${S}
   cp etc/linksysmon.conf ${D}/etc/ || die
   cp etc/init.d/linksysmon.gentoo ${D}/etc/init.d/linksysmon || die
   cp etc/cron.daily/linksysmon-report ${D}/etc/cron.daily/ || die
   cp etc/logrotate.d/linksysmon ${D}/etc/logrotate.d/ || die

   cp usr/sbin/linksysmon usr/sbin/linksysmon-ez-ipupdate \
   usr/sbin/linksysmon-ipchange usr/sbin/linksysmon-report \
   usr/sbin/linksysmon-watch ${D}/usr/sbin/ || die

   dodoc BUGS CHANGELOG COPYING README TODO

   perl Makefile.PL PREFIX=${D}/usr || die
   einstall || die
}
