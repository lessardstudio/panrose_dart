import 'package:flutter/material.dart';
import 'types.dart';

class TileInfoPanel extends StatelessWidget {
  final TileInfo? tileInfo;
  final DrawOptions options;

  const TileInfoPanel({
    super.key,
    required this.tileInfo,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    if (tileInfo == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Tile Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Room dimensions
            _buildSectionTitle('Room Dimensions'),
            _buildInfoRow('Width', '${options.roomWidth.toStringAsFixed(2)} m'),
            _buildInfoRow('Height', '${options.roomHeight.toStringAsFixed(2)} m'),
            _buildInfoRow('Area', '${(options.roomWidth * options.roomHeight).toStringAsFixed(2)} m²'),
            
            const SizedBox(height: 12),
            
            // Tile counts
            _buildSectionTitle('Tile Counts'),
            _buildInfoRow(
              'Thin rhombi (36°)',
              '${tileInfo!.thinCount}',
              color: const Color(0xFFFF5959),
            ),
            _buildInfoRow(
              'Thick rhombi (72°)',
              '${tileInfo!.thickCount}',
              color: const Color(0xFF6666FF),
            ),
            _buildInfoRow(
              'Total',
              '${tileInfo!.thinCount + tileInfo!.thickCount}',
              bold: true,
            ),
            
            const SizedBox(height: 12),
            
            // Tile dimensions
            _buildSectionTitle('Rhombus Dimensions'),
            _buildInfoRow('Side length', '${(tileInfo!.thinSide * 100).toStringAsFixed(1)} cm'),
            _buildInfoRow(
              'Thin area',
              '${(tileInfo!.thinArea * 10000).toStringAsFixed(2)} cm²',
            ),
            _buildInfoRow(
              'Thick area',
              '${(tileInfo!.thickArea * 10000).toStringAsFixed(2)} cm²',
            ),
            
            const SizedBox(height: 12),
            
            // Total coverage
            _buildSectionTitle('Coverage'),
            _buildInfoRow(
              'Total tile area',
              '${tileInfo!.totalArea.toStringAsFixed(3)} m²',
              bold: true,
            ),
            _buildInfoRow(
              'Coverage',
              '${((tileInfo!.totalArea / (options.roomWidth * options.roomHeight)) * 100).toStringAsFixed(1)}%',
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (color != null) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
