# Penrose Tiles - Flutter/Dart

Визуализация плиток Пенроуза на Flutter/Dart, портированная с TypeScript/React.

## Описание

Это приложение создает красивые паттерны плиток Пенроуза с возможностью настройки:
- Количества подразделений (subdivisions)
- Количества лучей (rays)
- Радиуса колеса (radius)

## Структура проекта

```
lib/
├── main.dart                    - Главный файл приложения
├── complex2.dart                - Класс для работы с комплексными числами
├── types.dart                   - Типы и структуры данных
├── penrose_tiles.dart           - Логика генерации и рисования плиток
├── penrose_tiles_painter.dart   - CustomPainter для Flutter
└── options_frame.dart           - Виджет с настройками
```

## Требования

- Flutter SDK 3.0.0 или выше
- Dart 3.0.0 или выше

## Установка и запуск

1. Убедитесь, что Flutter установлен:
```bash
flutter --version
```

2. Получите зависимости:
```bash
flutter pub get
```

3. Запустите приложение:

Для веб-версии:
```bash
flutter run -d chrome
```

Для мобильных устройств:
```bash
flutter run
```

Для десктопа (Windows/macOS/Linux):
```bash
flutter run -d windows
# или
flutter run -d macos
# или
flutter run -d linux
```

## Сборка

Для веб-версии:
```bash
flutter build web
```

Для Android:
```bash
flutter build apk
```

Для iOS:
```bash
flutter build ios
```

Для desktop:
```bash
flutter build windows
# или
flutter build macos
# или
flutter build linux
```

## Использование

После запуска приложения вы увидите визуализацию плиток Пенроуза. Используйте панель управления в правом верхнем углу для настройки:

- **Subdivisions** (0-9): Количество итераций подразделения треугольников
- **Rays** (2-50, четные числа): Количество начальных лучей
- **Radius**: Радиус колеса плиток

## Отличия от оригинальной версии

- Использует Flutter вместо React
- Использует Canvas API Flutter вместо HTML5 Canvas
- Нативная поддержка всех платформ (Web, Mobile, Desktop)
- Материальный дизайн вместо пользовательских стилей

## Лицензия

Этот проект является портом оригинальной TypeScript версии.
