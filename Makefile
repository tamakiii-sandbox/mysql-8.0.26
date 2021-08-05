.PHONY: help build run login stop check clean

NAME := tamakiii-sandbox/mysql-8.0.26
CONTAINER ?= $(shell docker container ls -q -f ancestor=$(NAME))

help:
	@cat $(firstword $(MAKEFILE_LIST))

build: Dockerfile
	docker build -t $(NAME) .

run:
	docker run --rm -e MYSQL_ALLOW_EMPTY_PASSWORD=yes $(NAME)

check:
	test -n "$(CONTAINER)"
	docker exec -it $(CONTAINER) mysql -u root -e "select SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME from INFORMATION_SCHEMA.SCHEMATA;"
	docker exec -it $(CONTAINER) mysql -u root -e "SHOW VARIABLES LIKE '%char%';"
	docker exec -it $(CONTAINER) mysql -u root -e "SHOW VARIABLES LIKE '%collation%';"

login:
	test -n "$(CONTAINER)"
	docker exec -it $(CONTAINER) mysql -u root -p

stop:
	test -n "$(CONTAINER)"
	docker stop $(CONTAINER)

clean:
	docker image rm -f $(NAME)
