import 'package:flutter/material.dart';
import 'penrose_tiles.dart';
import 'types.dart';

class PenroseTilesPainter extends CustomPainter {
  final DrawOptions options;

  PenroseTilesPainter(this.options);

  @override
  void paint(Canvas canvas, Size size) {
    drawPenroseTiles(
      canvas,
      options.numSubdivisions,
      options.numRays,
      options.wheelRadius,
      size,
    );
  }

  @override
  bool shouldRepaint(PenroseTilesPainter oldDelegate) {
    return options.numSubdivisions != oldDelegate.options.numSubdivisions ||
        options.numRays != oldDelegate.options.numRays ||
        options.wheelRadius != oldDelegate.options.wheelRadius;
  }
}
