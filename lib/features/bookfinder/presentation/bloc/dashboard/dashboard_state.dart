abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoaded extends DashboardState {
  final DeviceInfo deviceInfo;
  final bool isFlashlightOn;
  final bool isFlashlightAvailable;
  final bool isSensorMonitoring;
  final GyroscopeData? gyroscopeData;
  final AccelerometerData? accelerometerData;

  const DashboardLoaded({
    required this.deviceInfo,
    required this.isFlashlightOn,
    required this.isFlashlightAvailable,
    required this.isSensorMonitoring,
    this.gyroscopeData,
    this.accelerometerData,
  });

  DashboardLoaded copyWith({
    DeviceInfo? deviceInfo,
    bool? isFlashlightOn,
    bool? isFlashlightAvailable,
    bool? isSensorMonitoring,
    GyroscopeData? gyroscopeData,
    AccelerometerData? accelerometerData,
  }) {
    return DashboardLoaded(
      deviceInfo: deviceInfo ?? this.deviceInfo,
      isFlashlightOn: isFlashlightOn ?? this.isFlashlightOn,
      isFlashlightAvailable: isFlashlightAvailable ?? this.isFlashlightAvailable,
      isSensorMonitoring: isSensorMonitoring ?? this.isSensorMonitoring,
      gyroscopeData: gyroscopeData ?? this.gyroscopeData,
      accelerometerData: accelerometerData ?? this.accelerometerData,
    );
  }
}

class DashboardError extends DashboardState {
  const DashboardError({required String message});
}

class DeviceInfo {
  final String deviceName;
  final String manufacturer;
  final String brand;
  final String osVersion;
  final String platform;
  final int batteryLevel;

  DeviceInfo({
    required this.deviceName,
    required this.manufacturer,
    required this.brand,
    required this.osVersion,
    required this.platform,
    required this.batteryLevel,
  });
}

class GyroscopeData {
  final double x;
  final double y;
  final double z;

  GyroscopeData({
    required this.x,
    required this.y,
    required this.z,
  });
}

class AccelerometerData {
  final double x;
  final double y;
  final double z;

  AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
  });
}