class WidgetConfig {
  final int rows;
  final int columns;
  final double bgOpacity;
  final int bgTone;
  final double cornerRadius;
  final double iconSize;
  final bool showNonFavorites;
  final String presetName;

  WidgetConfig({
    required this.rows,
    required this.columns,
    required this.bgOpacity,
    required this.bgTone,
    required this.cornerRadius,
    required this.iconSize,
    required this.showNonFavorites,
    required this.presetName,
  });

  factory WidgetConfig.defaultConfig() => WidgetConfig(
    rows: 2,
    columns: 2,
    bgOpacity: 0.85,
    bgTone: 0,
    cornerRadius: 24.0,
    iconSize: 24.0,
    showNonFavorites: true,
    presetName: 'Pixel Monochrome',
  );

  WidgetConfig copyWith({
    int? rows,
    int? columns,
    double? bgOpacity,
    int? bgTone,
    double? cornerRadius,
    double? iconSize,
    bool? showNonFavorites,
    String? presetName,
  }) => WidgetConfig(
    rows: rows ?? this.rows,
    columns: columns ?? this.columns,
    bgOpacity: bgOpacity ?? this.bgOpacity,
    bgTone: bgTone ?? this.bgTone,
    cornerRadius: cornerRadius ?? this.cornerRadius,
    iconSize: iconSize ?? this.iconSize,
    showNonFavorites: showNonFavorites ?? this.showNonFavorites,
    presetName: presetName ?? this.presetName,
  );

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'columns': columns,
    'bgOpacity': bgOpacity,
    'bgTone': bgTone,
    'cornerRadius': cornerRadius,
    'iconSize': iconSize,
    'showNonFavorites': showNonFavorites,
    'presetName': presetName,
  };

  factory WidgetConfig.fromJson(Map<String, dynamic> json) => WidgetConfig(
    rows: json['rows'] as int,
    columns: json['columns'] as int,
    bgOpacity: json['bgOpacity'] as double,
    bgTone: json['bgTone'] as int,
    cornerRadius: json['cornerRadius'] as double,
    iconSize: json['iconSize'] as double,
    showNonFavorites: json['showNonFavorites'] as bool,
    presetName: json['presetName'] as String,
  );
}
