include srcs/.env
export

export VOLUMES_DIR
export MARIADB_VOLUME
export WORDPRESS_VOLUME

COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

all: setup run

re: stop all

fall: fclean all

init-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		cp -n ./srcs/.env.model $(ENV_FILE); \
	fi

setup: init-env
	mkdir -p secrets
	touch secrets/db_password.txt
	touch secrets/db_root_password.txt
	mkdir -p $(VOLUMES_DIR)
	mkdir -p $(MARIADB_VOLUME)
	mkdir -p $(WORDPRESS_VOLUME)

build:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) build

run:
	docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up --build -d

stop:
	docker-compose -f $(COMPOSE_FILE) down

fclean: stop docker-clean
	sudo rm -rf $(VOLUMES_DIR)

docker-clean:
	@docker stop $(docker ps -qa) 2>/dev/null || echo "No container to stop"
	@docker rm $(docker ps -qa) 2>/dev/null || echo "No container to rm"
	@docker rmi $(docker images -qa) 2>/dev/null || echo "No image to rm"
	@docker volume rm $(docker volume ls -q) 2>/dev/null || echo "No volume to rm"
	@docker network rm $(docker network ls -q) 2>/dev/null || echo "No network to rm"

.PHONY: all re fall init-env setup build run stop fclean docker-clean
