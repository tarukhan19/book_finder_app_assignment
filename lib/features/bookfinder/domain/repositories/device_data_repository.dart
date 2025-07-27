import '../../data/models/model_sys_sensor.dart';
import '../../data/models/model_sys_system.dart';

abstract class DeviceRepository {
  Future<SystemInfoModel> getSystemInfo();
  Future<void> toggleTorch(bool enabled);
   Future<bool> getTorchState();
  Stream<SensorDataModel> getGyroscopeStream();
}