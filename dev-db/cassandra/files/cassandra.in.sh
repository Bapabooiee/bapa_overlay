# Sourced by all the cassandra tools, as well as the init.d startup script
source /etc/conf.d/cassandra
source /usr/share/cassandra/package.env
CASSANDRA_CONF=/etc/cassandra/
CLASSPATH="${CLASSPATH}:${CASSANDRA_CONF}"
