import 'package:flutter/material.dart';
import 'types.dart';

class OptionsFrame extends StatelessWidget {
  final DrawOptions options;
  final ValueChanged<DrawOptions> onChanged;

  const OptionsFrame({
    super.key,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 280,
        height: MediaQuery.of(context).size.height * 0.9,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            const Text(
              'Parameters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSliderOption(
              label: 'Subdivisions ${options.numSubdivisions}',
              value: options.numSubdivisions.toDouble(),
              min: 0,
              max: 9,
              divisions: 9,
              onChanged: (value) {
                onChanged(options.copyWith(
                  numSubdivisions: value.toInt(),
                ));
              },
            ),
            const SizedBox(height: 8),
            _buildSliderOption(
              label: 'Rays ${options.numRays}',
              value: options.numRays.toDouble(),
              min: 2,
              max: 50,
              divisions: 24,
              onChanged: (value) {
                final rays = (value / 2).round() * 2; // Ensure even number
                onChanged(options.copyWith(
                  numRays: rays,
                ));
              },
            ),
            const SizedBox(height: 8),
            _buildNumberInput(
              label: 'Radius',
              value: options.wheelRadius,
              onChanged: (value) {
                onChanged(options.copyWith(
                  wheelRadius: value,
                ));
              },
            ),
            const Divider(height: 24),
            const Text(
              'Room Size',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRoomPresetDropdown(),
            const SizedBox(height: 8),
            _buildNumberInput(
              label: 'Width (m)',
              value: options.roomWidth,
              onChanged: (value) {
                onChanged(options.copyWith(
                  roomWidth: value,
                ));
              },
            ),
            const SizedBox(height: 8),
            _buildNumberInput(
              label: 'Height (m)',
              value: options.roomHeight,
              onChanged: (value) {
                onChanged(options.copyWith(
                  roomHeight: value,
                ));
              },
            ),
            const SizedBox(height: 8),
            _buildTileSizeDropdown(),
            const SizedBox(height: 8),
            _buildNumberInput(
              label: 'Tile side (m)',
              value: options.tileScale,
              step: 0.01,
              onChanged: (value) {
                onChanged(options.copyWith(
                  tileScale: value,
                ));
              },
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildTileSizeDropdown() {
    // Предустановленные размеры плиток
    final tileSizes = {
      'Custom': null,
      'Mini (5cm)': 0.05,
      'Small (7.5cm)': 0.075,
      'Standard (10cm)': 0.10,
      'Medium (12.5cm)': 0.125,
      'Large (15cm)': 0.15,
      'Extra large (20cm)': 0.20,
      'Decorative (25cm)': 0.25,
      'Statement (30cm)': 0.30,
    };

    // Определяем текущий размер
    String currentSize = 'Custom';
    for (final entry in tileSizes.entries) {
      if (entry.value != null &&
          (options.tileScale - entry.value!).abs() < 0.001) {
        currentSize = entry.key;
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tile size preset', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: currentSize,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
          items: tileSizes.keys.map((String size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(
                size,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (String? newSize) {
            if (newSize != null && newSize != 'Custom') {
              onChanged(options.copyWith(
                tileScale: tileSizes[newSize],
              ));
            }
          },
        ),
      ],
    );
  }

  Widget _buildRoomPresetDropdown() {
    // Предустановленные размеры комнат
    final presets = {
      'Custom': null,
      'Small bathroom (2×2m)': {'width': 2.0, 'height': 2.0},
      'Bathroom (2.5×3m)': {'width': 2.5, 'height': 3.0},
      'Kitchen (3×4m)': {'width': 3.0, 'height': 4.0},
      'Bedroom (3.5×4m)': {'width': 3.5, 'height': 4.0},
      'Living room (4×5m)': {'width': 4.0, 'height': 5.0},
      'Large bedroom (4×4.5m)': {'width': 4.0, 'height': 4.5},
      'Master bedroom (5×6m)': {'width': 5.0, 'height': 6.0},
      'Studio (6×8m)': {'width': 6.0, 'height': 8.0},
      'Large living (7×9m)': {'width': 7.0, 'height': 9.0},
      'Hall (10×15m)': {'width': 10.0, 'height': 15.0},
    };

    // Определяем текущий пресет
    String currentPreset = 'Custom';
    for (final entry in presets.entries) {
      if (entry.value != null &&
          (options.roomWidth - entry.value!['width']!).abs() < 0.01 &&
          (options.roomHeight - entry.value!['height']!).abs() < 0.01) {
        currentPreset = entry.key;
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Room preset', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: currentPreset,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
          items: presets.keys.map((String preset) {
            return DropdownMenuItem<String>(
              value: preset,
              child: Text(
                preset,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (String? newPreset) {
            if (newPreset != null && newPreset != 'Custom') {
              final preset = presets[newPreset]!;
              onChanged(options.copyWith(
                roomWidth: preset['width'],
                roomHeight: preset['height'],
              ));
            }
          },
        ),
      ],
    );
  }

  Widget _buildSliderOption({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNumberInput({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    double step = 1.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(
            text: value.toStringAsFixed(step < 1 ? 2 : 1),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
          onSubmitted: (text) {
            final newValue = double.tryParse(text);
            if (newValue != null && newValue > 0) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
