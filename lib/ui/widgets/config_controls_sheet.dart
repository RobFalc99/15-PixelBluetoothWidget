import 'package:flutter/material.dart';
import '../../models/widget_config.dart';
import '../../models/widget_presets.dart';
import '../../theme/pixel_tokens.dart';

class ConfigControlsSheet extends StatelessWidget {
  final WidgetConfig config;
  final Function(WidgetConfig) onConfigChanged;
  const ConfigControlsSheet({super.key, required this.config, required this.onConfigChanged});

  @override
  Widget build(BuildContext context) => Material(
    color: PixelTokens.surfaceDarkest,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: DefaultTextStyle(
        style: const TextStyle(color: PixelTokens.textPrimary, fontSize: 14),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Config', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final n in ['Pixel Minimal', 'Pixel Bar', 'Compact Matrix', 'Focus Dual'])
              ChoiceChip(
                label: Text(n),
                selected: config.presetName == n,
                selectedColor: PixelTokens.textPrimary,
                labelStyle: TextStyle(color: config.presetName == n ? Colors.black : PixelTokens.textPrimary),
                onSelected: (_) => onConfigChanged(WidgetPresets.all.firstWhere((p) => p.name == n).config),
              )
          ]),
          const SizedBox(height: 12),
          _slider('Rows', config.rows.toDouble(), 1, 4, (v) => onConfigChanged(config.copyWith(rows: v.round()))),
          _slider('Columns', config.columns.toDouble(), 1, 4, (v) => onConfigChanged(config.copyWith(columns: v.round()))),
          _slider('Opacity', config.bgOpacity, 0.2, 1.0, (v) => onConfigChanged(config.copyWith(bgOpacity: v))),
          _slider('Corner Radius', config.cornerRadius, 12, 28, (v) => onConfigChanged(config.copyWith(cornerRadius: v))),
          _slider('Icon Size', config.iconSize, 18, 36, (v) => onConfigChanged(config.copyWith(iconSize: v))),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('OLED Black')),
              ButtonSegment(value: 1, label: Text('Charcoal')),
              ButtonSegment(value: 2, label: Text('Surface Gray')),
            ],
            selected: {config.bgTone},
            onSelectionChanged: (s) => onConfigChanged(config.copyWith(bgTone: s.first)),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Show Non-Favorites'),
            value: config.showNonFavorites,
            onChanged: (v) => onConfigChanged(config.copyWith(showNonFavorites: v)),
          ),
        ]),
      ),
    ),
  );

  Widget _slider(String label, double value, double min, double max, ValueChanged<double> onChanged) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: PixelTokens.textPrimary)),
      Slider(
        value: value,
        min: min,
        max: max,
        divisions: (max - min).round(),
        activeColor: PixelTokens.textPrimary,
        inactiveColor: PixelTokens.surfaceBorder,
        onChanged: onChanged,
      ),
    ],
  );
}
