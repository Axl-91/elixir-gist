.PHONY: up down setup build run lint fmt test test.watch

up:
	docker-compose up -d

down:
	docker-compose down

build:
	mix do deps.get + compile

migrate: build
	mix ecto.migrate

run: build migrate 
	iex -S mix phx.server

run-server-only:
	mix phx.server

lint:
	mix format --check-formatted

fmt:
	mix format

test:
	mix test