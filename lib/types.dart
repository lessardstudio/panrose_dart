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

  DrawOptions({
    required this.numSubdivisions,
    required this.numRays,
    required this.wheelRadius,
  });

  DrawOptions copyWith({
    int? numSubdivisions,
    int? numRays,
    double? wheelRadius,
  }) {
    return DrawOptions(
      numSubdivisions: numSubdivisions ?? this.numSubdivisions,
      numRays: numRays ?? this.numRays,
      wheelRadius: wheelRadius ?? this.wheelRadius,
    );
  }
}
