import 'package:equatable/equatable.dart';
import '../../../../../core/platform/service_platform.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
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

  @override
  List<Object?> get props => [
    deviceInfo,
    isFlashlightOn,
    isFlashlightAvailable,
    isSensorMonitoring,
    gyroscopeData,
    accelerometerData,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}

class FlashlightToggling extends DashboardState {
  const FlashlightToggling();
}

class SensorDataUpdated extends DashboardState {
  final GyroscopeData gyroscopeData;
  final AccelerometerData? accelerometerData;

  const SensorDataUpdated({
    required this.gyroscopeData,
    this.accelerometerData,
  });

  @override
  List<Object?> get props => [gyroscopeData, accelerometerData];
}