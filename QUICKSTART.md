# Быстрый старт

## Что было портировано

Проект Penrose Tiles полностью портирован с TypeScript/React на Dart/Flutter:

### Файлы TypeScript → Dart

| TypeScript | Dart |
|------------|------|
| Complex2.ts | lib/complex2.dart |
| types.ts | lib/types.dart |
| PenroseTiles.ts | lib/penrose_tiles.dart |
| OptionsFrame.tsx | lib/options_frame.dart |
| index.tsx | lib/main.dart |

### Основные изменения

1. **React → Flutter**: Вместо React компонентов используются Flutter виджеты
2. **HTML Canvas → Flutter Canvas**: API рисования адаптирован под Flutter
3. **CSS → Flutter Layout**: Стили реализованы через Flutter виджеты
4. **Типы**: TypeScript типы портированы в Dart классы и enums

## Запуск приложения

```bash
# 1. Перейдите в директорию проекта
cd penrose_tiles

# 2. Получите зависимости
flutter pub get

# 3. Запустите приложение
flutter run -d chrome  # для веб-версии
# или
flutter run            # для подключенного устройства
```

## Как это работает

1. **main.dart** - точка входа, инициализирует приложение
2. **complex2.dart** - математические операции с комплексными числами
3. **types.dart** - определения типов (вершины, цвета, опции)
4. **penrose_tiles.dart** - алгоритм генерации плиток Пенроуза
5. **penrose_tiles_painter.dart** - CustomPainter для рисования
6. **options_frame.dart** - UI панель с настройками

## Поддерживаемые платформы

- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Примечания

- Для оптимальной производительности рекомендуется не превышать 7-8 subdivisions
- Количество лучей автоматически округляется до четного числа
- Radius можно изменить вручную или он будет рассчитан автоматически

## Возможные проблемы

Если возникают проблемы с запуском:

```bash
# Очистите кэш
flutter clean

# Получите зависимости заново
flutter pub get

# Проверьте версию Flutter
flutter doctor
```
