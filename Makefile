.PHONY: init init-migration build run db-migrate test tox

init:  build run
	docker-compose exec web app db migrate
	docker-compose exec web app db upgrade
	docker-compose exec web app init
	@echo "Init done, containers running"

build:
	docker-compose build

rerun:
	docker-compose down
	docker-compose up -d
	docker-compose exec web app db migrate
	docker-compose exec web app db upgrade
	docker-compose exec web app init

restart:
	docker-compose stop
	docker-compose start

run:
	docker-compose up -d

db-migrate:
	docker-compose exec web app db migrate

db-upgrade:
	docker-compose exec web app db upgrade

test:
	docker-compose stop celery # stop celery to avoid conflicts with celery tests
	docker-compose start rabbitmq redis # ensuring both redis and rabbitmq are started
	docker-compose run -v $(PWD)/tests:/code/tests:ro web tox -e test
	docker-compose start celery

tox:
	docker-compose stop celery # stop celery to avoid conflicts with celery tests
	docker-compose start rabbitmq redis # ensuring both redis and rabbitmq are started
	docker-compose run -v $(PWD)/tests:/code/tests:ro web tox -e py36
	docker-compose start celery

lint:
	docker-compose run web tox -e lint
