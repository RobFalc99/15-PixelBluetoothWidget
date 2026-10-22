import 'device_icon_type.dart' show DeviceIconType, DeviceIconTypeHelper;

class BtDeviceItem {
  final String id, macAddress, name;
  final String? customName;
  final DeviceIconType iconType;
  final bool isFavorite, isConnected, isConnecting;
  final int priorityOrder;

  const BtDeviceItem({
    required this.id,
    required this.macAddress,
    required this.name,
    this.customName,
    required this.iconType,
    this.isFavorite = false,
    this.isConnected = false,
    this.isConnecting = false,
    this.priorityOrder = 0,
  });

  String get displayName => (customName?.isNotEmpty ?? false) ? customName! : name;

  BtDeviceItem copyWith({
    String? id,
    String? macAddress,
    String? name,
    String? customName,
    DeviceIconType? iconType,
    bool? isFavorite,
    bool? isConnected,
    bool? isConnecting,
    int? priorityOrder,
  }) =>
      BtDeviceItem(
        id: id ?? this.id,
        macAddress: macAddress ?? this.macAddress,
        name: name ?? this.name,
        customName: customName ?? this.customName,
        iconType: iconType ?? this.iconType,
        isFavorite: isFavorite ?? this.isFavorite,
        isConnected: isConnected ?? this.isConnected,
        isConnecting: isConnecting ?? this.isConnecting,
        priorityOrder: priorityOrder ?? this.priorityOrder,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'macAddress': macAddress,
        'name': name,
        'customName': customName,
        'iconType': iconType.toJson(),
        'isFavorite': isFavorite,
        'isConnected': isConnected,
        'isConnecting': isConnecting,
        'priorityOrder': priorityOrder,
      };

  factory BtDeviceItem.fromJson(Map<String, dynamic> json) => BtDeviceItem(
        id: json['id'] as String,
        macAddress: json['macAddress'] as String,
        name: json['name'] as String,
        customName: json['customName'] as String?,
        iconType: DeviceIconTypeHelper.fromJson(json['iconType'] as String? ?? 'generic'),
        isFavorite: json['isFavorite'] as bool? ?? false,
        isConnected: json['isConnected'] as bool? ?? false,
        isConnecting: json['isConnecting'] as bool? ?? false,
        priorityOrder: json['priorityOrder'] as int? ?? 0,
      );
}
