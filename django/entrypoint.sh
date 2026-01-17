#!/bin/bash
# entrypoint.sh

set -e

echo "=== Django Application Entrypoint ==="
echo "Current user: $(whoami)"
echo "Working directory: $(pwd)"

# Ожидание доступности базы данных (используем netcat)
if [ -n "$DB_HOST" ] && [ -n "$DB_PORT" ]; then
    echo "Waiting for database at $DB_HOST:$DB_PORT..."
    while ! nc -z $DB_HOST $DB_PORT; do
        echo "Database is unavailable - sleeping"
        sleep 1
    done
    echo "Database is available!"
else
    echo "DB_HOST or DB_PORT not set, skipping database wait..."
fi

# Выполняем миграции
echo "Running database migrations..."
python manage.py migrate --noinput

# Собираем статические файлы
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

# Создаем суперпользователя если указаны учетные данные
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    echo "Creating superuser: $DJANGO_SUPERUSER_USERNAME"
    python manage.py shell << EOF
import os
from django.contrib.auth.models import User

username = os.environ.get('DJANGO_SUPERUSER_USERNAME')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD')

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password)
    print(f'Superuser {username} created successfully.')
else:
    print(f'Superuser {username} already exists.')
EOF
else
    echo "Superuser credentials not provided. Skipping superuser creation."
    echo "To create a superuser, set DJANGO_SUPERUSER_USERNAME and DJANGO_SUPERUSER_PASSWORD environment variables."
fi

# Запускаем основную команду (gunicorn или runserver)
echo "Starting application..."
exec "$@"
