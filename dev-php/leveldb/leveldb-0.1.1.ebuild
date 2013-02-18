EAPI=4

USE_PHP="php5-3 php5-4"
PHP_EXT_NAME="leveldb"

inherit php-ext-source-r2 php-ext-pecl-r2

DESCRIPTION="LevelDB module for PHP"
HOMEPAGE="http://reeze.cn/php-leveldb"
SRC_URI="${SRC_URI} -> pecl-leveldb-${PV}.tgz"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/leveldb"
RDEPEND="${DEPEND}"

src_configure() {
	my_conf="--with-leveldb=/usr"

	php-ext-source-r2_src_configure
}
