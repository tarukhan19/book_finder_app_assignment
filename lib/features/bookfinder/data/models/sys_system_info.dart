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
}