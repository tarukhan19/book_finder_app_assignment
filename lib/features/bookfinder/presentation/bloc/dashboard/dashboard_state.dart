import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_info_sensor.dart';
import '../../../domain/entities/entity_info_system.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoaded extends DashboardState {
  final SystemInfoEntity systemInfo;
  final bool isFlashlightOn;
  final bool isFlashlightAvailable;
  final bool isSensorMonitoring;
  final SensorDataEntity? sensorData;

  const DashboardLoaded({
    required this.systemInfo,
    required this.isFlashlightOn,
    required this.isFlashlightAvailable,
    required this.isSensorMonitoring,
    this.sensorData,
  });

  DashboardLoaded copyWith({
    SystemInfoEntity? systemInfo,
    bool? isFlashlightOn,
    bool? isFlashlightAvailable,
    bool? isSensorMonitoring,
    SensorDataEntity? sensorData,
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