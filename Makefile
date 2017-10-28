DOCKER=$(shell which docker)
DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
DOCKER_EXEC := $(DOCKER) exec -it

CONTAINER_FOR_APP01_SETUP := isucon7-app01
CONTAINER_FOR_APP02_SETUP := isucon7-app02
CONTAINER_FOR_DB_SETUP := isucon7-app03
DB_HOST := localhost
DB_USER := root

ps:
	$(DOCKER_COMPOSE) ps

up:
	$(DOCKER_COMPOSE) up -d
	$(DOCKER_EXEC) $(CONTAINER_FOR_APP01_SETUP) sudo /etc/init.d/nginx start
	$(DOCKER_EXEC) $(CONTAINER_FOR_APP02_SETUP) sudo /etc/init.d/nginx start
	$(DOCKER_EXEC) $(CONTAINER_FOR_DB_SETUP) sudo /etc/init.d/mysql start

app/start:
	$(MAKE) -j app/start/app01 app/start/app02

app/start/app01:
	$(DOCKER_EXEC) $(CONTAINER_FOR_APP01_SETUP) sh -x /home/isucon/isubata/docker/setup_app.sh

app/start/app02:
	$(DOCKER_EXEC) $(CONTAINER_FOR_APP02_SETUP) sh -x /home/isucon/isubata/docker/setup_app.sh

clean: stop rm

stop:
	$(DOCKER_COMPOSE) stop

rm:
	$(DOCKER_COMPOSE) rm -f

logs/%:
	$(DOCKER_COMPOSE) logs $*

attach/%:
	$(DOCKER_EXEC) isucon7-$* /bin/bash

