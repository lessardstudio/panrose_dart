import 'complex2.dart';

enum VertexColor {
  red,
  blue,
}

class Vertex {
  final VertexColor color;
  final Complex2 a;
  final Complex2 b;
  final Complex2 c;

  Vertex(this.color, this.a, this.b, this.c);
}

class DrawOptions {
  final int numSubdivisions;
  final int numRays;
  final double wheelRadius;
  final double roomWidth;  // Ширина комнаты в метрах
  final double roomHeight; // Высота комнаты в метрах
  final double tileScale;  // Масштаб плитки (базовый размер стороны ромба в метрах)

  DrawOptions({
    required this.numSubdivisions,
    required this.numRays,
    required this.wheelRadius,
    this.roomWidth = 5.0,   // По умолчанию 5 метров
    this.roomHeight = 5.0,  // По умолчанию 5 метров
    this.tileScale = 0.1,   // По умолчанию 10 см (0.1 м) сторона ромба
  });

  DrawOptions copyWith({
    int? numSubdivisions,
    int? numRays,
    double? wheelRadius,
    double? roomWidth,
    double? roomHeight,
    double? tileScale,
  }) {
    return DrawOptions(
      numSubdivisions: numSubdivisions ?? this.numSubdivisions,
      numRays: numRays ?? this.numRays,
      wheelRadius: wheelRadius ?? this.wheelRadius,
      roomWidth: roomWidth ?? this.roomWidth,
      roomHeight: roomHeight ?? this.roomHeight,
      tileScale: tileScale ?? this.tileScale,
    );
  }
}

// Информация о размерах ромбов Пенроуза
class TileInfo {
  final int thinCount;      // Количество тонких ромбов
  final int thickCount;     // Количество толстых ромбов
  final double thinArea;    // Площадь одного тонкого ромба (м²)
  final double thickArea;   // Площадь одного толстого ромба (м²)
  final double totalArea;   // Общая площадь всех ромбов (м²)
  final double thinSide;    // Длина стороны тонкого ромба (м)
  final double thickSide;   // Длина стороны толстого ромба (м)

  TileInfo({
    required this.thinCount,
    required this.thickCount,
    required this.thinArea,
    required this.thickArea,
    required this.totalArea,
    required this.thinSide,
    required this.thickSide,
  });
}
