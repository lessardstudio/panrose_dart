# check_files.ps1
Write-Host "🔍 Проверка структуры проекта..." -ForegroundColor Cyan
Write-Host ""

$errors = 0

# Проверка файлов
function Check-File {
    param($Path)
    if (Test-Path $Path) {
        Write-Host "✓ $Path" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ $Path НЕ НАЙДЕН!" -ForegroundColor Red
        return $false
    }
}

# Проверка директорий
function Check-Directory {
    param($Path)
    if (Test-Path -PathType Container $Path) {
        Write-Host "✓ $Path\" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ $Path\ НЕ НАЙДЕНА!" -ForegroundColor Red
        return $false
    }
}

Write-Host "📋 Конфигурационные файлы:" -ForegroundColor Yellow
if (-not (Check-File "pubspec.yaml")) { $errors++ }
if (-not (Check-File "Dockerfile")) { $errors++ }
if (-not (Check-File "docker-compose.yml")) { $errors++ }
Write-Host ""

Write-Host "📂 Директории:" -ForegroundColor Yellow
if (-not (Check-Directory "lib")) { $errors++ }
if (-not (Check-Directory "web")) { $errors++ }
Write-Host ""

Write-Host "📝 Dart файлы:" -ForegroundColor Yellow
if (-not (Check-File "lib\main.dart")) { $errors++ }
if (-not (Check-File "lib\types.dart")) { $errors++ }
if (-not (Check-File "lib\complex2.dart")) { $errors++ }
if (-not (Check-File "lib\penrose_tiles.dart")) { $errors++ }
if (-not (Check-File "lib\penrose_tiles_painter.dart")) { $errors++ }
if (-not (Check-File "lib\options_frame.dart")) { $errors++ }
Write-Host ""

Write-Host "🌐 Web файлы:" -ForegroundColor Yellow
if (-not (Check-File "web\index.html")) { $errors++ }
if (-not (Check-File "web\manifest.json")) { $errors++ }
Write-Host ""

Write-Host "================================" -ForegroundColor Cyan
if ($errors -eq 0) {
    Write-Host "✅ Все проверки пройдены!" -ForegroundColor Green
    Write-Host "Проект готов к сборке Docker образа." -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Найдено ошибок: $errors" -ForegroundColor Red
    Write-Host "Исправьте ошибки перед сборкой." -ForegroundColor Red
    
    Write-Host ""
    Write-Host "Если файлы на месте, но проверка не проходит:" -ForegroundColor Yellow
    Write-Host "1. Убедитесь, что вы находитесь в корне проекта" -ForegroundColor White
    Write-Host "2. Проверьте кодировку файлов (должна быть UTF-8)" -ForegroundColor White
    Write-Host "3. Убедитесь, что нет скрытых символов в именах файлов" -ForegroundColor White
    
    exit 1
}
