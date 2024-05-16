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
	docker-compose run --rm api bundle exec rails db:migrate

create-db:
	docker-compose run --rm api bundle exec rails db:create

drop-db:
	docker-compose run --rm api bundle exec rails db:drop

seed:
	docker-compose run --rm api bundle exec rails db:seed

shell:
	docker-compose exec -it api bash

console:
	docker-compose run --rm api bundle exec rails console

test:
	RAILS_ENV=test docker-compose run --rm api bundle exec rspec

logs:
	docker-compose logs -f

swag:
	docker-compose run --rm -e SWAGGER_DRY_RUN=0 api bundle exec rake rswag:specs:swaggerize

.PHONY: up build down clean restart migrate create-db drop-db seed shell console test logs
