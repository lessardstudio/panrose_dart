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
        width: 240,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
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
          ],
        ),
      ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value.toStringAsFixed(1)),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
          onSubmitted: (text) {
            final newValue = double.tryParse(text);
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
