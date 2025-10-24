FROM mariadb:12.0-ubi

ADD --chown=1001:0 ./data-seed/pyrrha.sql /docker-entrypoint-initdb.d/