FROM docker.io/library/mariadb:10.3

ADD --chown=1001:0 ./data-seed/pyrrha.sql /docker-entrypoint-initdb.d