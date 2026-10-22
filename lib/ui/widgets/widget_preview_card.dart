import 'package:flutter/material.dart';

import '../../models/bt_device_item.dart';
import '../../models/widget_config.dart';
import '../../theme/pixel_tokens.dart';
import 'device_tile_widget.dart';

class WidgetPreviewCard extends StatelessWidget {
  final WidgetConfig config;
  final List<BtDeviceItem> devices;
  final Function(String) onToggleConnection;
  final Function(BtDeviceItem) onEditDevice;

  const WidgetPreviewCard({
    super.key,
    required this.config,
    required this.devices,
    required this.onToggleConnection,
    required this.onEditDevice,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = devices.where((d) => d.isFavorite).toList()
      ..sort((a, b) => a.priorityOrder.compareTo(b.priorityOrder));
    final others = devices.where((d) => !d.isFavorite && d.isConnected).toList()
      ..sort((a, b) => a.priorityOrder.compareTo(b.priorityOrder));

    final tone =
        [PixelTokens.surfaceDarkest, PixelTokens.surfaceDark, PixelTokens.surfaceMedium]
            [config.bgTone.clamp(0, 2)];
    final bgColor = tone.withAlpha((config.bgOpacity * 255).round());
    final count = (config.rows * config.columns).clamp(0, favorites.length);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(config.cornerRadius),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: count,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: config.columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, i) => DeviceTileWidget(
            device: favorites[i],
            iconSize: config.iconSize,
            onTap: () => onToggleConnection(favorites[i].macAddress),
            onLongPress: () => onEditDevice(favorites[i]),
          ),
        ),
        if (config.showNonFavorites && others.isNotEmpty) ...[
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: others
                  .map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: DeviceTileWidget(
                        device: d,
                        isCompact: true,
                        iconSize: config.iconSize * 0.85,
                        onTap: () => onToggleConnection(d.macAddress),
                        onLongPress: () => onEditDevice(d),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ]),
    );
  }
}
