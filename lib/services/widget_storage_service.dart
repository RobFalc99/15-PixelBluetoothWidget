import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/widget_config.dart';
import '../models/bt_device_item.dart';

class WidgetStorageService {
  static const String _keyConfig = 'pixel_widget_config';
  static const String _keyDevices = 'pixel_widget_devices';

  static Future<void> saveConfig(WidgetConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(config.toJson());
    await prefs.setString(_keyConfig, json);
  }

  static Future<WidgetConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyConfig);
    if (json == null) return WidgetConfig.defaultConfig();
    return WidgetConfig.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  static Future<void> saveDevices(List<BtDeviceItem> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(devices.map((d) => d.toJson()).toList());
    await prefs.setString(_keyDevices, json);
  }

  static Future<List<BtDeviceItem>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyDevices);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((item) => BtDeviceItem.fromJson(item as Map<String, dynamic>)).toList();
  }
}
