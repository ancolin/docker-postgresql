#!/bin/ash
set -e

case ${1} in
  app:start|app:backup|app:debug)

    case ${1} in
      app:start)
        if [ ! -d ${PGDATA} ]; then
          POSTGRES_HBA_CONF=/var/lib/postgresql/data/pg_hba.conf
          POSTGRES_CONF=/var/lib/postgresql/data/postgresql.conf
          if [ "${POSTGRES_ALLOW_IPADDRESS}" = '' ]; then
            POSTGRES_ALLOW_IPADDRESS=0.0.0.0
          fi
          if [ "${POSTGRES_ALLOW_SUBNETMASK}" = '' ]; then
            POSTGRES_ALLOW_SUBNETMASK=0
          fi
          initdb --encoding utf8 --no-locale -D ${PGDATA}
          echo "host  all  all ${POSTGRES_ALLOW_IPADDRESS}/${POSTGRES_ALLOW_SUBNETMASK} trust" >> ${POSTGRES_HBA_CONF}
          echo "listen_addresses = '*'" >> ${POSTGRES_CONF}
        fi
        pg_ctl start -w -D ${PGDATA}
        tail -f /dev/null
        ;;
      app:backup)
        backup_name="${PGDATA}_backup_$(date +'%Y%m%d%H%M%S')"
        echo "backup PGDATA directory to ${backup_name}"
        pg_basebackup -D ${backup_name}
        ;;
      app:debug)
        tail -f /dev/null
        ;;
      *)
        ;;
    esac
    ;;
  *)
    echo "Available options:"
    echo "  app:start - Start DB cluster."
    echo "  app:backup - Backup DB cluster."
    ;;
esac

exit