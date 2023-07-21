up: docker-up
build: docker-build
down: docker-down
restart: down up
stop: docker-stop
start: docker-start
init: docker-down-clear docker-build docker-up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-start:
	docker-compose start

docker-stop:
	docker-compose stop

docker-build:
	docker-compose build

docker-build-image:
	docker --log-level=debug build --no-cache --pull \
	--build-arg="UID=1000" \
	--build-arg="GID=1000" \
	--build-arg="USER=app" \
	--file=Dockerfile \
	--tag=pankovalxndr/fpm:develop-1 ./

docker-push-image:
	docker push pankovalxndr/fpm:develop-1

php:
	docker-compose exec php bash