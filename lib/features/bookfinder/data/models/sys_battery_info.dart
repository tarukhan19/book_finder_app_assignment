class BatteryInfoModel {
  final int batteryLevel;
  final String batteryState;
  final bool isCharging;

  BatteryInfoModel({
    required this.batteryLevel,
    required this.batteryState,
    required this.isCharging,
  });

  factory BatteryInfoModel.fromMap(Map<String, dynamic> map) {
    return BatteryInfoModel(
      batteryLevel: map['batteryLevel'] ?? 0,
      batteryState: map['batteryState'] ?? 'unknown',
      isCharging: map['isCharging'] ?? false,
    );
  }
}