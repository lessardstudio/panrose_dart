.PHONY: help build run stop restart logs clean dev test verify

help: ## Показать это сообщение помощи
	@echo "Доступные команды:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

verify: ## Проверить структуру проекта перед сборкой
	@./verify.sh

build: verify ## Собрать Docker образ
	docker-compose build

run: ## Запустить контейнер
	docker-compose up -d
	@echo "Приложение доступно на http://localhost:8080"

stop: ## Остановить контейнер
	docker-compose down

restart: ## Перезапустить контейнер
	docker-compose restart

logs: ## Показать логи
	docker-compose logs -f

clean: ## Удалить контейнеры, образы и volumes
	docker-compose down -v
	docker rmi penrose-tiles_penrose-tiles 2>/dev/null || true

dev: ## Запустить Flutter в режиме разработки (без Docker)
	flutter pub get
	flutter run -d chrome

test: ## Запустить тесты
	flutter test

install: ## Установить зависимости Flutter
	flutter pub get

build-web: ## Собрать web-версию локально
	flutter build web --release
	@echo "Результат сборки в ./build/web"

docker-build-no-cache: ## Собрать Docker образ без кэша
	docker-compose build --no-cache

docker-shell: ## Открыть shell в контейнере
	docker-compose exec penrose-tiles sh

docker-prune: ## Очистить неиспользуемые Docker ресурсы
	docker system prune -af

all: build run ## Собрать и запустить
