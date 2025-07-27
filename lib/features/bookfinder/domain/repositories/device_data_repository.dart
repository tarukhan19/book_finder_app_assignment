import '../entities/entity_info_sensor.dart';
import '../entities/entity_info_system.dart';

abstract class DeviceRepository {
  Future<SystemInfoEntity> getSystemInfo();
  Future<void> toggleTorch(bool enabled);
  Future<bool> getTorchState();
  Stream<SensorDataEntity> getGyroscopeStream();
}