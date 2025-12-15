# Используем официальный образ Flutter
FROM ghcr.io/cirruslabs/flutter:stable

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файл конфигурации
COPY pubspec.yaml ./

# Копируем файлы из lib/ по одному для надежности
COPY lib/main.dart ./lib/
COPY lib/types.dart ./lib/
COPY lib/complex2.dart ./lib/
COPY lib/penrose_tiles.dart ./lib/
COPY lib/penrose_tiles_painter.dart ./lib/
COPY lib/options_frame.dart ./lib/

# Копируем web файлы
COPY web/index.html ./web/
COPY web/manifest.json ./web/

# Включаем поддержку web
RUN flutter config --enable-web

# Устанавливаем зависимости
RUN flutter pub get

# Собираем приложение для web
RUN flutter build web --release

# Production stage - используем nginx
FROM nginx:alpine

# Копируем собранное приложение
COPY --from=0 /app/build/web /usr/share/nginx/html

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# Используем nginx для раздачи статических файлов
FROM nginx:alpine

# Копируем собранное приложение из предыдущего stage
COPY --from=0 /app/build/web /usr/share/nginx/html

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
