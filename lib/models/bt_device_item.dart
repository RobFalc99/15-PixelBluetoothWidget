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

  factory BtDeviceItem.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as String?)?.trim();
    final macAddress = (json['macAddress'] as String?)?.trim();
    final name = (json['name'] as String?)?.trim();
    final customName = (json['customName'] as String?)?.trim();
    final address = (json['address'] as String?)?.trim();
    
    return BtDeviceItem(
      id: (id?.isNotEmpty ?? false) ? id! : ((macAddress?.isNotEmpty ?? false) ? macAddress! : (address ?? 'dev_0')),
      macAddress: (macAddress?.isNotEmpty ?? false) ? macAddress! : (address ?? ((id?.isNotEmpty ?? false) ? id! : '00:00:00:00:00:00')),
      name: (name?.isNotEmpty ?? false) ? name! : 'Bluetooth Device',
      customName: (customName?.isNotEmpty ?? false) ? customName : null,
      iconType: DeviceIconTypeHelper.fromJson((json['iconType'] as String?)?.trim() ?? 'generic'),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isConnected: json['isConnected'] as bool? ?? false,
      isConnecting: json['isConnecting'] as bool? ?? false,
      priorityOrder: json['priorityOrder'] as int? ?? 0,
    );
  }
}
