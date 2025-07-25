import '../../../domain/entities/info_sensor.dart';

abstract class DashboardEvent {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {
  const LoadDashboardDataEvent();
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

class UpdateAccelerometerDataEvent extends DashboardEvent {
  final SensorData data;
  const UpdateAccelerometerDataEvent(this.data);
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