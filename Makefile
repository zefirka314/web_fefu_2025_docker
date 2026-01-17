.PHONY: dev up down logs clean test migrate shell

# Разработка
dev:
	ENV=dev docker-compose up --build

up:
	ENV=dev docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f web

# Миграции
migrate:
	docker-compose exec web python manage.py migrate

makemigrations:
	docker-compose exec web python manage.py makemigrations

# Администрирование
shell:
	docker-compose exec web python manage.py shell

createsuperuser:
	docker-compose exec web python manage.py createsuperuser

# Продакшн
prod-build:
	ENV=prod docker-compose -f docker-compose.yml -f docker-compose.prod.yml build

prod-up:
	ENV=prod docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

prod-down:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

# Очистка
clean:
	docker-compose down -v
	docker system prune -f

# Тестирование
test:
	docker-compose exec web python manage.py test
