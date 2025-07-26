class SystemInfoModel {
  final String deviceModel;
  final String osVersion;
  final String platform;
  final int batteryLevel;

  SystemInfoModel({
    required this.deviceModel,
    required this.osVersion,
    required this.platform,
    required this.batteryLevel
  });

  factory SystemInfoModel.fromMap(Map<String, dynamic> map) {
    return SystemInfoModel(
      deviceModel: map['deviceModel'] ?? '',
      osVersion: map['osVersion'] ?? '',
      platform: map['platform'] ?? '',
      batteryLevel: map['batteryLevel'] ?? 0,
    );
  }
}