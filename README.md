### postgresql 11.3

# Overview

# Up
`docker-compose up -d db`

# Run command
`docker-compose exec db psql -l` 

# Backup
* `docker-compose exec db pg_dump DB > FILENAME`
* `docker-compose exec db pg_basebackup -D DIRECTORY`
