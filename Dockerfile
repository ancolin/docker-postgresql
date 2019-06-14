FROM alpine:latest
MAINTAINER ancolin

ENV PGDATA=/var/lib/postgresql/data

RUN apk --update --no-cache add \
    postgresql \
    tzdata \
 && cp /usr/share/zoneinfo/Japan /etc/localtime \
 && apk del tzdata \
 && echo "export PGDATA=${PGDATA}" > /etc/profile.d/postgresql.sh \
 && mkdir -p /run/postgresql \
 && chown postgres:postgres /run/postgresql

COPY entrypoint.sh /usr/bin/
RUN chmod a+x /usr/bin/entrypoint.sh

USER postgres
ENTRYPOINT ["entrypoint.sh"]
CMD ["app:start"]
