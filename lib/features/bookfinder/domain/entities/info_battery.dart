class BatteryInfo {
  final int batteryLevel;
  final BatteryState batteryState;
  final bool isCharging;

  BatteryInfo({
    required this.batteryLevel,
    required this.batteryState,
    required this.isCharging,
  });
}

enum BatteryState { charging, discharging, notCharging, full, unknown }
