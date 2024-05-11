SHELL := /bin/bash

up:
	docker-compose up

build:
	docker-compose build

down:
	docker-compose down

clean:
	docker-compose down -v

restart: down up

migrate:
	docker-compose run --rm api rails db:migrate

create-db:
	docker-compose run --rm api rails db:create

drop-db:
	docker-compose run --rm api rails db:drop

seed:
	docker-compose run --rm api rails db:seed

console:
	docker-compose run --rm api rails console

test:
	docker-compose run --rm api rails test

logs:
	docker-compose logs -f

.PHONY: up build down clean restart migrate create-db drop-db seed console test logs
