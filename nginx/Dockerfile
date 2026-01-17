FROM nginx:alpine

# Установка curl для healthcheck
RUN apk add --no-cache curl

# Копирование конфигурации
COPY nginx.conf /etc/nginx/nginx.conf

# Создание директории для статики
RUN mkdir -p /app/static

