class SystemInfoEntity {
  final String deviceModel;
  final String osVersion;
  final String platform;
  final String batteryLevel;

  SystemInfoEntity({
    required this.deviceModel,
    required this.osVersion,
    required this.platform,
    required this.batteryLevel,
  });

  factory SystemInfoEntity.fromMap(Map<String, dynamic> map) {
    return SystemInfoEntity(
      deviceModel: map['deviceModel'] ?? '',
      osVersion: map['osVersion'] ?? '',
      platform: map['platform'] ?? '',
      batteryLevel: map['batteryInfo'] ?? '',
    );
  }
}