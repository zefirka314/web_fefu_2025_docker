# Build stage
FROM python:3.11 as builder

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    musl-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копирование requirements
COPY requirements/ /app/requirements/

# Создание виртуального окружения и установка зависимостей
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements/dev.txt

# Копирование проекта
COPY . /app/
ENV DJANGO_SETTINGS_MODULE=config.settings.build
# Сборка статических файлов (опционально, можно комментировать если собираете в entrypoint)
# RUN python manage.py collectstatic --noinput

# Production stage
FROM python:3.11-slim

# Создание пользователя без привилегий
RUN groupadd -r django && useradd -r -g django django

# Установка системных зависимостей для production
RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Копирование виртуального окружения из builder
COPY --from=builder /opt/venv /opt/venv

# Копирование исходного кода
COPY --from=builder /app /app

WORKDIR /app

# Копируем entrypoint скрипт и делаем его исполняемым
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Настройка прав доступа
RUN chown -R django:django /app

# Переключение на непривилегированного пользователя
USER django

# Настройка пути
ENV PATH="/opt/venv/bin:$PATH"

# Настройка переменных окружения
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Порт
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

# Entrypoint и команда
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
