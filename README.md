sudo docker-compose up -d #запуск докера в фоновом режиме
sudo docker-compose exec web python manage.py migrate #выолнить миграции
