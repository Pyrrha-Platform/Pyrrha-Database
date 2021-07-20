FROM docker.io/library/mariadb:10.3

ADD ./data/pyrrha.sql /docker-entrypoint-initdb.d
