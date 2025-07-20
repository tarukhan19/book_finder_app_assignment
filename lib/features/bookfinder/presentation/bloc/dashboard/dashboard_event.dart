import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {
  const LoadDashboardDataEvent();
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}

class ToggleFlashlightEvent extends DashboardEvent {
  const ToggleFlashlightEvent();
}

class StartSensorMonitoringEvent extends DashboardEvent {
  const StartSensorMonitoringEvent();
}

class StopSensorMonitoringEvent extends DashboardEvent {
  const StopSensorMonitoringEvent();
}

class UpdateBatteryLevelEvent extends DashboardEvent {
  final int batteryLevel;

  const UpdateBatteryLevelEvent({required this.batteryLevel});

  @override
  List<Object> get props => [batteryLevel];
}

class UpdateGyroscopeDataEvent extends DashboardEvent {
  final double x;
  final double y;
  final double z;

  const UpdateGyroscopeDataEvent({
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  List<Object> get props => [x, y, z];
}