import 'dart:math';
import 'dart:ui';
import 'complex2.dart';
import 'types.dart';

const double goldenRatio = 1.618033988749895; // (1 + sqrt(5)) / 2

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

void drawPenroseTiles(
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
}
