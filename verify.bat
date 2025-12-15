@echo off
echo Checking project structure...
echo.

set errors=0

echo Configuration files:
if exist "pubspec.yaml" (
    echo [OK] pubspec.yaml
) else (
    echo [ERROR] pubspec.yaml NOT FOUND!
    set /a errors+=1
)

if exist "Dockerfile" (
    echo [OK] Dockerfile
) else (
    echo [ERROR] Dockerfile NOT FOUND!
    set /a errors+=1
)

if exist "docker-compose.yml" (
    echo [OK] docker-compose.yml
) else (
    echo [ERROR] docker-compose.yml NOT FOUND!
    set /a errors+=1
)

echo.
echo Directories:
if exist "lib\" (
    echo [OK] lib\
) else (
    echo [ERROR] lib\ NOT FOUND!
    set /a errors+=1
)

if exist "web\" (
    echo [OK] web\
) else (
    echo [ERROR] web\ NOT FOUND!
    set /a errors+=1
)

echo.
echo Dart files:
if exist "lib\main.dart" (
    echo [OK] lib\main.dart
) else (
    echo [ERROR] lib\main.dart NOT FOUND!
    set /a errors+=1
)

if exist "lib\types.dart" (
    echo [OK] lib\types.dart
) else (
    echo [ERROR] lib\types.dart NOT FOUND!
    set /a errors+=1
)

if exist "lib\complex2.dart" (
    echo [OK] lib\complex2.dart
) else (
    echo [ERROR] lib\complex2.dart NOT FOUND!
    set /a errors+=1
)

if exist "lib\penrose_tiles.dart" (
    echo [OK] lib\penrose_tiles.dart
) else (
    echo [ERROR] lib\penrose_tiles.dart NOT FOUND!
    set /a errors+=1
)

if exist "lib\penrose_tiles_painter.dart" (
    echo [OK] lib\penrose_tiles_painter.dart
) else (
    echo [ERROR] lib\penrose_tiles_painter.dart NOT FOUND!
    set /a errors+=1
)

if exist "lib\options_frame.dart" (
    echo [OK] lib\options_frame.dart
) else (
    echo [ERROR] lib\options_frame.dart NOT FOUND!
    set /a errors+=1
)

if exist "lib\tile_info_panel.dart" (
    echo [OK] lib\tile_info_panel.dart
) else (
    echo [ERROR] lib\tile_info_panel.dart NOT FOUND!
    set /a errors+=1
)

echo.
echo Web files:
if exist "web\index.html" (
    echo [OK] web\index.html
) else (
    echo [ERROR] web\index.html NOT FOUND!
    set /a errors+=1
)

if exist "web\manifest.json" (
    echo [OK] web\manifest.json
) else (
    echo [ERROR] web\manifest.json NOT FOUND!
    set /a errors+=1
)

echo.
echo ================================
if %errors% EQU 0 (
    echo SUCCESS! All checks passed!
    echo Project is ready for Docker build.
    echo.
    echo Run: docker compose up --build
    exit /b 0
) else (
    echo FAILED! Errors found: %errors%
    echo.
    echo Files in lib folder:
    dir /b lib 2>nul
    echo.
    echo Please make sure ALL files are copied from outputs folder!
    exit /b 1
)
