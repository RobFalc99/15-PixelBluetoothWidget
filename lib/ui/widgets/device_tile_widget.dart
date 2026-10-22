import 'package:flutter/material.dart';

import '../../models/bt_device_item.dart';
import '../../models/device_icon_type.dart';
import '../../theme/pixel_tokens.dart';

class DeviceTileWidget extends StatelessWidget {
  const DeviceTileWidget({
    super.key,
    required this.device,
    required this.iconSize,
    required this.onTap,
    required this.onLongPress,
    this.isCompact = false,
  });

  final BtDeviceItem device;
  final double iconSize;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final borderColor = device.isConnected ? PixelTokens.textPrimary : PixelTokens.surfaceBorder;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: PixelTokens.touchTargetMinimum,
        minHeight: PixelTokens.touchTargetMinimum,
      ),
      child: Material(
        color: device.isConnected ? PixelTokens.surfaceMedium : PixelTokens.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PixelTokens.radiusSubtle),
          side: BorderSide(color: borderColor, width: device.isConnected ? 1.5 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(PixelTokens.radiusSubtle),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 16, vertical: isCompact ? 8 : 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_iconFor(device.iconType), size: iconSize, color: PixelTokens.textPrimary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    device.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: PixelTokens.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                if (device.isConnecting) ...[
                  const SizedBox(width: 12),
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 1.8, valueColor: AlwaysStoppedAnimation(PixelTokens.textPrimary)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(DeviceIconType type) => switch (type) {
      DeviceIconType.earbuds => Icons.headphones,
      DeviceIconType.headphones => Icons.headphones,
      DeviceIconType.speaker => Icons.speaker,
      DeviceIconType.watch => Icons.watch,
      DeviceIconType.car => Icons.directions_car,
      DeviceIconType.keyboard => Icons.keyboard,
      DeviceIconType.mouse => Icons.mouse,
      DeviceIconType.phone => Icons.phone_android,
      DeviceIconType.generic => Icons.devices,
    };
