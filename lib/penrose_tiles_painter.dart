import 'package:flutter/material.dart';
import 'penrose_tiles.dart';
import 'types.dart';

class PenroseTilesPainter extends CustomPainter {
  final DrawOptions options;
  final Function(TileInfo)? onTileInfoCalculated;

  PenroseTilesPainter(this.options, {this.onTileInfoCalculated});

  @override
  void paint(Canvas canvas, Size size) {
    final triangles = drawPenroseTiles(
      canvas,
      options.numSubdivisions,
      options.numRays,
      options.wheelRadius,
      size,
    );
    
    // Рассчитываем информацию о плитках после рисования
    if (onTileInfoCalculated != null && triangles.isNotEmpty) {
      final tileInfo = calculateTileInfo(
        triangles, 
        options.tileScale,
        options.roomWidth,
        options.roomHeight,
      );
      // Вызываем callback в следующем фрейме, чтобы избежать изменения состояния во время paint
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onTileInfoCalculated!(tileInfo);
      });
    }
  }

  @override
  bool shouldRepaint(PenroseTilesPainter oldDelegate) {
    return options.numSubdivisions != oldDelegate.options.numSubdivisions ||
        options.numRays != oldDelegate.options.numRays ||
        options.wheelRadius != oldDelegate.options.wheelRadius ||
        options.tileScale != oldDelegate.options.tileScale ||
        options.roomWidth != oldDelegate.options.roomWidth ||
        options.roomHeight != oldDelegate.options.roomHeight;
  }
}
