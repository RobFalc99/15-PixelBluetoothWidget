import 'widget_config.dart';

class PresetItem {
  final String name;
  final String description;
  final WidgetConfig config;

  PresetItem({
    required this.name,
    required this.description,
    required this.config,
  });
}

class WidgetPresets {
  static List<PresetItem> get all => [
    PresetItem(
      name: 'Pixel Minimal',
      description: 'Compact 2x2 grid with OLED black background',
      config: WidgetConfig(
        rows: 2,
        columns: 2,
        bgTone: 0,
        bgOpacity: 0.90,
        cornerRadius: 24,
        iconSize: 26,
        showNonFavorites: true,
        presetName: 'Pixel Minimal',
      ),
    ),
    PresetItem(
      name: 'Pixel Bar',
      description: 'Vertical 1x4 bar with charcoal background',
      config: WidgetConfig(
        rows: 1,
        columns: 4,
        bgTone: 1,
        bgOpacity: 0.85,
        cornerRadius: 28,
        iconSize: 24,
        showNonFavorites: false,
        presetName: 'Pixel Bar',
      ),
    ),
    PresetItem(
      name: 'Compact Matrix',
      description: 'Dense 3x3 matrix with high opacity',
      config: WidgetConfig(
        rows: 3,
        columns: 3,
        bgTone: 1,
        bgOpacity: 0.95,
        cornerRadius: 16,
        iconSize: 20,
        showNonFavorites: true,
        presetName: 'Compact Matrix',
      ),
    ),
    PresetItem(
      name: 'Focus Dual',
      description: 'Minimal 1x2 layout with large icons and opaque background',
      config: WidgetConfig(
        rows: 1,
        columns: 2,
        bgTone: 0,
        bgOpacity: 1.0,
        cornerRadius: 28,
        iconSize: 32,
        showNonFavorites: false,
        presetName: 'Focus Dual',
      ),
    ),
  ];
}
