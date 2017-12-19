build: ## Build docker image
	docker-compose -f ./docker/docker-compose.yml build

start-local: ## Start web application
	mix ecto.create
	mix ecto.migrate
	mix run priv/repo/seeds.exs
	mix phx.server

start: ## Start web application
	docker-compose -f ./docker/docker-compose.yml up -d postgres
	docker-compose -f ./docker/docker-compose.yml run phoenix mix ecto.create
	docker-compose -f ./docker/docker-compose.yml run phoenix mix ecto.migrate
	docker-compose -f ./docker/docker-compose.yml run phoenix mix run priv/repo/seeds.exs
	docker-compose -f ./docker/docker-compose.yml up phoenix

#
# Help
#

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
