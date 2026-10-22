import 'package:flutter/services.dart';

import '../models/bt_device_item.dart';
import '../models/device_icon_type.dart';
import '../models/widget_config.dart';

class BtChannelService {
  static const MethodChannel _channel = MethodChannel('com.robfalc.pixelbt/bluetooth');

  static Future<List<BtDeviceItem>> getBondedDevices() async {
    try {
      final raw = await _channel.invokeMethod<List<dynamic>>('getBondedDevices');
      if (raw == null || raw.isEmpty) return _mockDevices;
      return raw
          .whereType<Map>()
          .map((m) => BtDeviceItem.fromJson(m.cast<String, dynamic>()))
          .toList(growable: false);
    } on PlatformException {
      return _mockDevices;
    } on MissingPluginException {
      return _mockDevices;
    }
  }

  static Future<bool> toggleDevice(String macAddress, bool currentlyConnected) async {
    try {
      final res = await _channel.invokeMethod<bool>(
        'toggleDevice',
        <String, dynamic>{'mac': macAddress, 'connect': !currentlyConnected},
      );
      return res ?? !currentlyConnected;
    } on PlatformException {
      return !currentlyConnected;
    } on MissingPluginException {
      return !currentlyConnected;
    }
  }

  static Future<void> syncWidgetData(WidgetConfig config, List<BtDeviceItem> devices) async {
    await _channel.invokeMethod<void>('updateWidget', <String, dynamic>{
      'config': config.toJson(),
      'devices': devices.map((d) => d.toJson()).toList(growable: false),
    });
  }

  static const List<BtDeviceItem> _mockDevices = <BtDeviceItem>[
    BtDeviceItem(
      id: 'pixel-buds-pro',
      macAddress: 'AA:BB:CC:11:22:01',
      name: 'Pixel Buds Pro',
      iconType: DeviceIconType.earbuds,
      isFavorite: true,
      isConnected: true,
      priorityOrder: 1,
    ),
    BtDeviceItem(
      id: 'sony-wh1000xm5',
      macAddress: 'AA:BB:CC:11:22:02',
      name: 'Sony WH-1000XM5',
      iconType: DeviceIconType.headphones,
      isFavorite: true,
      isConnected: false,
      priorityOrder: 2,
    ),
    BtDeviceItem(
      id: 'pixel-watch-2',
      macAddress: 'AA:BB:CC:11:22:03',
      name: 'Pixel Watch 2',
      iconType: DeviceIconType.watch,
      isFavorite: false,
      isConnected: true,
      priorityOrder: 3,
    ),
    BtDeviceItem(
      id: 'car-audio-bt',
      macAddress: 'AA:BB:CC:11:22:04',
      name: 'Car Audio BT',
      iconType: DeviceIconType.car,
      isFavorite: false,
      isConnected: false,
      priorityOrder: 4,
    ),
  ];
}
