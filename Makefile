start-db: ## Start postgres in docker
	docker-compose -f ./docker/docker-compose.yml up -d db

reset-db: ## Reset database
	cd ./server && mix ecto.reset

migrate-db: ## Migrate database
	cd ./server && mix ecto.migrate

start: ## Start web application
	cd ./server && mix phx.server

#
# Help
#

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
