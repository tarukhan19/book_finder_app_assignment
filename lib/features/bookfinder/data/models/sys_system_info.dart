class SystemInfoModel {
  final String deviceModel;
  final String osVersion;
  final String platform;
  final String appVersion;

  SystemInfoModel({
    required this.deviceModel,
    required this.osVersion,
    required this.platform,
    required this.appVersion,
  });

  factory SystemInfoModel.fromMap(Map<String, dynamic> map) {
    return SystemInfoModel(
      deviceModel: map['deviceModel'] ?? '',
      osVersion: map['osVersion'] ?? '',
      platform: map['platform'] ?? '',
      appVersion: map['appVersion'] ?? '',
    );
  }
}