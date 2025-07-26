import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/info_sensor.dart';

import '../../../domain/entities/info_system.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoaded extends DashboardState {
  final SystemInfo systemInfo;
  final bool isFlashlightOn;
  final bool isFlashlightAvailable;
  final bool isSensorMonitoring;
  final SensorData? sensorData;

  const DashboardLoaded({
    required this.systemInfo,
    required this.isFlashlightOn,
    required this.isFlashlightAvailable,
    required this.isSensorMonitoring,
    this.sensorData,
  });

  DashboardLoaded copyWith({
    SystemInfo? systemInfo,
    bool? isFlashlightOn,
    bool? isFlashlightAvailable,
    bool? isSensorMonitoring,
    SensorData? sensorData,
  }) {
    return DashboardLoaded(
      systemInfo: systemInfo ?? this.systemInfo,
      isFlashlightOn: isFlashlightOn ?? this.isFlashlightOn,
      isFlashlightAvailable: isFlashlightAvailable ?? this.isFlashlightAvailable,
      isSensorMonitoring: isSensorMonitoring ?? this.isSensorMonitoring,
      sensorData: sensorData ?? this.sensorData,
    );
  }
}

class DashboardError extends DashboardState {
  const DashboardError({required String message});
}