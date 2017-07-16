#!/bin/ash
set -e

case ${1} in
  app:start)
    POSTGRES_HBA_CONF=/var/lib/postgresql/data/pg_hba.conf
    POSTGRES_CONF=/var/lib/postgresql/data/postgresql.conf
    IP_ADDRESS=$(ip addr show eth0 | grep inet | awk '{print $2}')
    IP_BLOADCAST=$(echo ${IP_ADDRESS} | awk -F '.' '{print $1"."$2"."$3".0"}')
    IP_SUBNET=$(echo ${IP_BLOADCAST})/$(echo ${IP_ADDRESS} | awk -F '/' '{print $2}')

    case ${1} in
      app:start)
        if [ ! -d ${PGDATA} ]; then
          su - postgres -c "initdb --encoding utf8 --no-locale -D ${PGDATA}"
        fi
        echo "host    all             all             ${IP_SUBNET}           trust" >> ${POSTGRES_HBA_CONF}
        echo "listen_addresses = '*'" >> ${POSTGRES_CONF}
        su - postgres -c "pg_ctl start -w -D ${PGDATA}"
        tail -f /dev/null
        ;;
      *)
        ;;
    esac
    ;;
  *)
    echo "Available options:"
    echo "  app:start - Start DB cluster."
    ;;
esac

exit