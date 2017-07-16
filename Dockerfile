FROM alpine:3.6
MAINTAINER ancolin

ENV PGDATA=/var/lib/postgresql/data

RUN apk update && \
  apk upgrade && \
  apk add \
    postgresql \
    tzdata && \
  cp /usr/share/zoneinfo/Japan /etc/localtime && \
  apk del tzdata && \
  rm -rf /var/cache/apk/* && \
  echo "export PGDATA=${PGDATA}" > /etc/profile.d/postgresql.sh && \
  mkdir -p /run/postgresql && \
  chown postgres:postgres /run/postgresql

COPY entrypoint.sh /
ENTRYPOINT ["ash", "entrypoint.sh"]
CMD ["app:start"]
