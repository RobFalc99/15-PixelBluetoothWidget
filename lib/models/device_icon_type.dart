import 'package:flutter/material.dart';

enum DeviceIconType {
  earbuds,
  headphones,
  speaker,
  watch,
  car,
  keyboard,
  mouse,
  phone,
  generic,
}

extension DeviceIconTypeHelper on DeviceIconType {
  String get label {
    return switch (this) {
      DeviceIconType.earbuds => 'Pixel Buds / Earbuds',
      DeviceIconType.headphones => 'Headphones',
      DeviceIconType.speaker => 'Speaker',
      DeviceIconType.watch => 'Watch',
      DeviceIconType.car => 'Car',
      DeviceIconType.keyboard => 'Keyboard',
      DeviceIconType.mouse => 'Mouse',
      DeviceIconType.phone => 'Phone',
      DeviceIconType.generic => 'Device',
    };
  }

  IconData get icon {
    return switch (this) {
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
  }

  String toJson() => name;

  static DeviceIconType fromJson(String value) {
    return DeviceIconType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DeviceIconType.generic,
    );
  }
}
