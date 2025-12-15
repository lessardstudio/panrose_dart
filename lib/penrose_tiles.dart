import 'dart:math';
import 'dart:ui';
import 'complex2.dart';
import 'types.dart';

const double goldenRatio = 1.618033988749895; // (1 + sqrt(5)) / 2

// Углы ромбов Пенроуза
const double thinAngle = 36 * pi / 180;   // 36 градусов (тонкий ромб)
const double thickAngle = 72 * pi / 180;  // 72 градуса (толстый ромб)

// A + (B - A) / goldenRatio
Complex2 subdividePoint(Complex2 a, Complex2 b) {
  return b.clone().sub(a).divScalar(goldenRatio).add(a);
}

List<Vertex> subdivide(List<Vertex> triangles) {
  final result = <Vertex>[];
  
  for (final vertex in triangles) {
    final color = vertex.color;
    final a = vertex.a;
    final b = vertex.b;
    final c = vertex.c;
    
    if (color == VertexColor.red) {
      // Subdivide red triangle
      final p = subdividePoint(a, b);
      result.add(Vertex(VertexColor.red, c, p, b));
      result.add(Vertex(VertexColor.blue, p, c, a));
    } else {
      // Subdivide blue triangle
      final q = subdividePoint(b, a);
      final r = subdividePoint(b, c);
      result.add(Vertex(VertexColor.blue, r, c, a));
      result.add(Vertex(VertexColor.blue, q, r, b));
      result.add(Vertex(VertexColor.red, r, q, a));
    }
  }
  
  return result;
}

List<Vertex> drawPenroseTiles(
  Canvas canvas,
  int numSubdivisions,
  int raysCount,
  double wheelRadius,
  Size canvasSize,
) {
  // Create wheel of red triangles around the origin
  List<Vertex> triangles = [];
  
  for (int i = 0; i < raysCount; i++) {
    Complex2 b = Complex2.fromPolar(1, ((2 * i - 1) * pi) / raysCount);
    Complex2 c = Complex2.fromPolar(1, ((2 * i + 1) * pi) / raysCount);
    
    if (i % 2 == 0) {
      // Make sure to mirror every second triangle
      final z = b;
      b = c;
      c = z;
    }
    
    triangles.add(Vertex(VertexColor.red, Complex2.zero(), b, c));
  }
  
  // Perform subdivisions
  for (int i = 0; i < numSubdivisions; i++) {
    triangles = subdivide(triangles);
  }
  
  // Save canvas state
  canvas.save();
  
  // Translate to center and scale
  canvas.translate(canvasSize.width / 2.0, canvasSize.height / 2.0);
  canvas.scale(wheelRadius, wheelRadius);
  
  // Draw red triangles
  final redPaint = Paint()
    ..color = const Color(0xFFFF5959) // rgb(255, 89, 89)
    ..style = PaintingStyle.fill;
  
  for (final vertex in triangles) {
    if (vertex.color == VertexColor.red) {
      final path = Path()
        ..moveTo(vertex.a.real, vertex.a.imag)
        ..lineTo(vertex.b.real, vertex.b.imag)
        ..lineTo(vertex.c.real, vertex.c.imag)
        ..close();
      canvas.drawPath(path, redPaint);
    }
  }
  
  // Draw blue triangles
  final bluePaint = Paint()
    ..color = const Color(0xFF6666FF) // rgb(102, 102, 255)
    ..style = PaintingStyle.fill;
  
  for (final vertex in triangles) {
    if (vertex.color == VertexColor.blue) {
      final path = Path()
        ..moveTo(vertex.a.real, vertex.a.imag)
        ..lineTo(vertex.b.real, vertex.b.imag)
        ..lineTo(vertex.c.real, vertex.c.imag)
        ..close();
      canvas.drawPath(path, bluePaint);
    }
  }
  
  // Determine line width from size of first triangle
  if (triangles.isNotEmpty) {
    final firstVertex = triangles[0];
    final lineWidth = firstVertex.b.clone().sub(firstVertex.a).abs() / 10.0;
    
    // Draw outlines
    final outlinePaint = Paint()
      ..color = const Color(0xFF333333) // rgb(51, 51, 51)
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeJoin = StrokeJoin.round;
    
    for (final vertex in triangles) {
      final path = Path()
        ..moveTo(vertex.c.real, vertex.c.imag)
        ..lineTo(vertex.a.real, vertex.a.imag)
        ..lineTo(vertex.b.real, vertex.b.imag);
      canvas.drawPath(path, outlinePaint);
    }
  }
  
  // Restore canvas state
  canvas.restore();
  
  // Возвращаем треугольники для расчета информации
  return triangles;
}

// Рассчитать информацию о размерах ромбов
TileInfo calculateTileInfo(
  List<Vertex> triangles,
  double tileScale, // Базовый размер стороны в метрах
  double roomWidth,
  double roomHeight,
) {
  // Площадь комнаты
  final roomArea = roomWidth * roomHeight;
  
  // Площадь одного тонкого и толстого ромба
  final thinArea = tileScale * tileScale * sin(thinAngle);
  final thickArea = tileScale * tileScale * sin(thickAngle);
  
  // Определяем соотношение тонких и толстых ромбов из паттерна
  int patternThinCount = 0;
  int patternThickCount = 0;
  
  for (final vertex in triangles) {
    if (vertex.color == VertexColor.red) {
      patternThinCount++;
    } else {
      patternThickCount++;
    }
  }
  
  // В паттерне 2 треугольника = 1 ромб
  patternThinCount = (patternThinCount / 2).ceil();
  patternThickCount = (patternThickCount / 2).ceil();
  
  // Соотношение тонких к толстым ромбам в паттерне
  final totalPatternTiles = patternThinCount + patternThickCount;
  final thinRatio = patternThinCount / totalPatternTiles;
  final thickRatio = patternThickCount / totalPatternTiles;
  
  // Средняя площадь одного ромба с учетом соотношения
  final avgTileArea = (thinArea * thinRatio) + (thickArea * thickRatio);
  
  // Общее количество плиток, которые поместятся в комнату
  final totalTilesNeeded = (roomArea / avgTileArea).floor();
  
  // Распределяем по типам согласно соотношению в паттерне
  final thinCount = (totalTilesNeeded * thinRatio).round();
  final thickCount = (totalTilesNeeded * thickRatio).round();
  
  // Реальная общая площадь плиток
  final totalArea = (thinCount * thinArea) + (thickCount * thickArea);

  return TileInfo(
    thinCount: thinCount,
    thickCount: thickCount,
    thinArea: thinArea,
    thickArea: thickArea,
    totalArea: totalArea,
    thinSide: tileScale,
    thickSide: tileScale,
  );
}
