import 'package:flutter/foundation.dart';
import '../models/widget_config.dart';
import '../models/bt_device_item.dart';
import '../models/device_icon_type.dart';
import '../services/widget_storage_service.dart';
import '../services/bt_channel_service.dart';

class WidgetEditorState extends ChangeNotifier {
  WidgetEditorState();

  WidgetConfig _config = WidgetConfig.defaultConfig();
  List<BtDeviceItem> _devices = const <BtDeviceItem>[];
  bool _isLoading = false;

  WidgetConfig get config => _config;
  List<BtDeviceItem> get devices => _devices;
  bool get isLoading => _isLoading;

  Future<void> _mutate(
    bool Function(BtDeviceItem) test,
    BtDeviceItem Function(BtDeviceItem) update,
  ) async {
    _devices = [for (final d in _devices) test(d) ? update(d) : d];
    await WidgetStorageService.saveDevices(_devices);
    await BtChannelService.syncWidgetData(_config, _devices);
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      _config = await WidgetStorageService.loadConfig();
      final saved = await WidgetStorageService.loadDevices();
      final bonded = await BtChannelService.getBondedDevices();
      _devices = bonded.map((b) {
        final s = saved.firstWhere(
          (e) => e.macAddress == b.macAddress,
          orElse: () => b,
        );
        return b.copyWith(
          customName: s.customName,
          iconType: s.iconType,
          isFavorite: s.isFavorite,
          priorityOrder: s.priorityOrder,
        );
      }).toList()
        ..sort((a, b) => a.priorityOrder.compareTo(b.priorityOrder));
      await BtChannelService.syncWidgetData(_config, _devices);
    } catch (_) {
      // Fallback to mock devices on any error to prevent blank/broken UI
      _devices = await BtChannelService.getBondedDevices();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConfig(WidgetConfig newConfig) async {
    _config = newConfig;
    await WidgetStorageService.saveConfig(newConfig);
    notifyListeners();
    await BtChannelService.syncWidgetData(_config, _devices);
  }

  Future<void> toggleFavorite(String id) =>
      _mutate((d) => d.id == id, (d) => d.copyWith(isFavorite: !d.isFavorite));
  Future<void> updateDeviceCustomName(String id, String customName) =>
      _mutate((d) => d.id == id, (d) => d.copyWith(customName: customName));
  Future<void> updateDeviceIcon(String id, DeviceIconType iconType) =>
      _mutate((d) => d.id == id, (d) => d.copyWith(iconType: iconType));
  Future<void> toggleDeviceConnection(String macAddress) async {
    await _mutate(
      (d) => d.macAddress == macAddress,
      (d) => d.copyWith(isConnecting: true),
    );
    final device = _devices.firstWhere((d) => d.macAddress == macAddress);
    final connected = await BtChannelService.toggleDevice(macAddress, device.isConnected);
    await _mutate(
      (d) => d.macAddress == macAddress,
      (d) => d.copyWith(isConnected: connected, isConnecting: false),
    );
  }
}
