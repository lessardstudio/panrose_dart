#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Проверка структуры проекта..."
echo ""

# Проверка наличия необходимых файлов
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1 отсутствует!"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
        return 0
    else
        echo -e "${RED}✗${NC} $1/ отсутствует!"
        return 1
    fi
}

errors=0

# Проверка основных файлов
echo "📋 Конфигурационные файлы:"
check_file "pubspec.yaml" || ((errors++))
check_file "analysis_options.yaml" || ((errors++))
check_file "Dockerfile" || ((errors++))
check_file "docker-compose.yml" || ((errors++))
echo ""

# Проверка директорий
echo "📂 Директории:"
check_dir "lib" || ((errors++))
check_dir "web" || ((errors++))
echo ""

# Проверка Dart файлов
echo "📝 Dart файлы:"
check_file "lib/main.dart" || ((errors++))
check_file "lib/types.dart" || ((errors++))
check_file "lib/complex2.dart" || ((errors++))
check_file "lib/penrose_tiles.dart" || ((errors++))
check_file "lib/penrose_tiles_painter.dart" || ((errors++))
check_file "lib/options_frame.dart" || ((errors++))
echo ""

# Проверка web файлов
echo "🌐 Web файлы:"
check_file "web/index.html" || ((errors++))
check_file "web/manifest.json" || ((errors++))
echo ""

# Проверка импортов
echo "🔗 Проверка импортов в Dart файлах..."
if grep -q "import 'types.dart';" lib/main.dart; then
    echo -e "${GREEN}✓${NC} main.dart → types.dart"
else
    echo -e "${RED}✗${NC} main.dart не импортирует types.dart"
    ((errors++))
fi

if grep -q "import 'types.dart';" lib/options_frame.dart; then
    echo -e "${GREEN}✓${NC} options_frame.dart → types.dart"
else
    echo -e "${RED}✗${NC} options_frame.dart не импортирует types.dart"
    ((errors++))
fi

if grep -q "import 'types.dart';" lib/penrose_tiles.dart; then
    echo -e "${GREEN}✓${NC} penrose_tiles.dart → types.dart"
else
    echo -e "${RED}✗${NC} penrose_tiles.dart не импортирует types.dart"
    ((errors++))
fi

echo ""
echo "================================"
if [ $errors -eq 0 ]; then
    echo -e "${GREEN}✅ Все проверки пройдены!${NC}"
    echo "Проект готов к сборке Docker образа."
    exit 0
else
    echo -e "${RED}❌ Найдено ошибок: $errors${NC}"
    echo "Исправьте ошибки перед сборкой."
    exit 1
fi
