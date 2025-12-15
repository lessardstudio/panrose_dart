@echo off
chcp 65001 >nul
echo 🔍 Проверка структуры проекта...
echo.

set errors=0

echo 📋 Конфигурационные файлы:
if exist "pubspec.yaml" (
    echo ✓ pubspec.yaml
) else (
    echo ✗ pubspec.yaml НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "Dockerfile" (
    echo ✓ Dockerfile
) else (
    echo ✗ Dockerfile НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "docker-compose.yml" (
    echo ✓ docker-compose.yml
) else (
    echo ✗ docker-compose.yml НЕ НАЙДЕН!
    set /a errors+=1
)

echo.
echo 📂 Директории:
if exist "lib\" (
    echo ✓ lib\
) else (
    echo ✗ lib\ НЕ НАЙДЕНА!
    set /a errors+=1
)

if exist "web\" (
    echo ✓ web\
) else (
    echo ✗ web\ НЕ НАЙДЕНА!
    set /a errors+=1
)

echo.
echo 📝 Dart файлы:
if exist "lib\main.dart" (
    echo ✓ lib\main.dart
) else (
    echo ✗ lib\main.dart НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "lib\types.dart" (
    echo ✓ lib\types.dart
) else (
    echo ✗ lib\types.dart НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "lib\complex2.dart" (
    echo ✓ lib\complex2.dart
) else (
    echo ✗ lib\complex2.dart НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "lib\penrose_tiles.dart" (
    echo ✓ lib\penrose_tiles.dart
) else (
    echo ✗ lib\penrose_tiles.dart НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "lib\penrose_tiles_painter.dart" (
    echo ✓ lib\penrose_tiles_painter.dart
) else (
    echo ✗ lib\penrose_tiles_painter.dart НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "lib\options_frame.dart" (
    echo ✓ lib\options_frame.dart
) else (
    echo ✗ lib\options_frame.dart НЕ НАЙДЕН!
    set /a errors+=1
)

echo.
echo 🌐 Web файлы:
if exist "web\index.html" (
    echo ✓ web\index.html
) else (
    echo ✗ web\index.html НЕ НАЙДЕН!
    set /a errors+=1
)

if exist "web\manifest.json" (
    echo ✓ web\manifest.json
) else (
    echo ✗ web\manifest.json НЕ НАЙДЕН!
    set /a errors+=1
)

echo.
echo ================================
if %errors% EQU 0 (
    echo ✅ Все проверки пройдены!
    echo Проект готов к сборке Docker образа.
    exit /b 0
) else (
    echo ❌ Найдено ошибок: %errors%
    echo.
    echo ВАЖНО: Убедитесь, что все файлы скопированы из outputs!
    echo.
    echo Список необходимых файлов:
    dir /b lib 2>nul
    echo.
    exit /b 1
)
